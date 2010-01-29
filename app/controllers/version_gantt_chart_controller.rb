require 'user_tasks'
require 'user_task_gantt'

class VersionGanttChartController < ApplicationController
  helper :projects
  unloadable

  def index
    events = []

    #プロジェクト一覧作成
    projects = Project.find :all, :conditions => Project.visible_by(User.current)

    #全ユーザをユーザリストに追加
    user_list = User.find(:all)

    #ダミーユーザをユーザリストに追加
    user_list.push NobodyUser.new

    #ユーザグループをユーザリストに追加
    user_groups = Group.find(:all)
    user_groups.each do |group|
      user_group_wrapper = UserGroupWrapper.new(group)
      user_list.push user_group_wrapper
    end

    #ユーザとプロジェクトの全組合せでユーザタスクを作成
    user_list.each do |user|
      projects.each do |project|
        if project.active?
          project.versions.each do |version|
            add_usertasks( user, version, events )
          end
          add_usertasks( user, BlankVersion.new(project), events )
        end
      end
    end

    from_date = Date.today - 15
    months = from_date.month == Date.today.month ? 3 : 4 
    @gantt = UserTaskGantt.new(:months=>4, :year=>from_date.year, :month=>from_date.month, :months=>months)
    @gantt.events = events.sort
  end

  def add_usertasks( user, version, events )
    user_tasks = UserTasks.new( user, version )
    version.fixed_issues.each do |issue|
      user_tasks.add issue
    end
    events.push( user_tasks ) unless user_tasks.empty?
  end
end
