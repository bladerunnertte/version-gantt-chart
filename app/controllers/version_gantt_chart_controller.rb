require 'user_tasks'
require 'user_task_gantt'

class VersionGanttChartController < ApplicationController
  helper :projects
  unloadable

  def index
    #ダミーユーザをユーザリストに追加
    @principal_list = unassigned_users

    #アクティブでアクセス権限のあるユーザとグループの一覧を取得
    member_principals = principals_in_visible_project
    @principal_list.concat( member_principals )
    @group_list = extract_groups( member_principals )

    #ガントチャートインスタンス作成
    @gantt = UserTaskGantt.new(params.merge({:users=>@principal_list}))

    #ユーザとプロジェクトの全組合せでユーザタスクを作成
    events = []
    projects = Project.find :all, :conditions => Project.visible_condition(User.current)
    @principal_list.each do |user|
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

  def all
    visible_principals = unassigned_users
    visible_principals.concat(principals_in_visible_project)
    redirect_to_index(visible_principals)
  end


  def all_user
    visible_principals = unassigned_users
    visible_principals.concat(extract_users(principals_in_visible_project))
    redirect_to_index(visible_principals)
  end


  def all_group
    visible_principals = unassigned_users
    visible_principals.concat(extract_groups(principals_in_visible_project))
    redirect_to_index(visible_principals)
  end


  def current
    visible_principals = unassigned_users
    visible_principals.push User.current
    redirect_to_index(visible_principals)
  end

  def group
    visible_principals = unassigned_users

    selected_group = Group.find(params[:id])
    visible_principals.concat( selected_group.users )

    redirect_to_index(visible_principals)
  end

private
  def add_usertasks( user, version, events )
    user_tasks = UserTasks.new( user, version )
    version.fixed_issues.each do |issue|
      user_tasks.add issue
    end
    events.push( user_tasks ) unless user_tasks.empty?
  end

  def unassigned_users
    user_list = []
    user_list.push NobodyUser.new
  end

  def principals_in_visible_project
    user_list = []

    projects = Project.find :all, :conditions => Project.visible_condition(User.current)
    projects.each do |project|
      user_list.concat(project.principals)
    end
    user_list.uniq!
    user_list.sort
  end

  def extract_users(principals)
    user_list = []
    principals.each do |principal|
      user_list.push principal if principal.is_a?(User)
    end
    user_list
  end

  def extract_groups(principals)
    group_list = []
    principals.each do |principal|
      group_list.push principal if principal.is_a?(Group)
    end
    group_list
  end

  def redirect_to_index visible_users
    visible_user_ids = []

    visible_users.each do |user|
      visible_user_ids.push user.id.to_s 
    end

    redirect_to :action => 'index', :visible => visible_user_ids
  end
end
