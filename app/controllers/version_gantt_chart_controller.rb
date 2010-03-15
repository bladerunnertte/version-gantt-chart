require 'user_tasks'
require 'user_task_gantt'

class VersionGanttChartController < ApplicationController
  helper :projects
  unloadable

  def index

    #ダミーユーザをユーザリストに追加
    @user_list = []
    @user_list.push NobodyUser.new

    #アクティブなユーザ一覧を取得
    active_users = User.find(:all, :conditions => ["status = ?",User::STATUS_ACTIVE])
    active_users.sort!{|a,b| a.name <=> b.name}
    @user_list.concat(active_users)

    #ユーザグループをユーザリストに追加
    user_groups = Group.find(:all)
    user_groups.sort!{|a,b| a.lastname <=> b.lastname}
    user_groups.each do |group|
      user_group_wrapper = UserGroupWrapper.new(group)
      @user_list.push user_group_wrapper
    end

    #ガントチャートインスタンス作成
    @gantt = UserTaskGantt.new(params.merge({:users=>@user_list}))

    #プロジェクト一覧作成
    projects = Project.find :all, :conditions => Project.visible_by(User.current)

    #ユーザとプロジェクトの全組合せでユーザタスクを作成
    events = []
    @user_list.each do |user|
      if @gantt.visible?(user)
        projects.each do |project|
          if project.active?
            project.versions.each do |version|
              add_usertasks( user, version, events )
            end
            add_usertasks( user, BlankVersion.new(project), events )
          end
        end
      end
    end

    @gantt.events = events.sort
  end

private
  def add_usertasks( user, version, events )
    user_tasks = UserTasks.new( user, version )
    version.fixed_issues.each do |issue|
      user_tasks.add issue
    end
    events.push( user_tasks ) unless user_tasks.empty?
  end
end
