require 'user_tasks'
require 'user_task_gantt'

class VersionGanttChartController < ApplicationController
  helper :projects
  unloadable

  def index
    events = []

    user_list = User.find(:all)
    user_list.each do |user|
      user.projects.each do |project|
        if project.active? && ( User.current.admin? || User.current.member_of?(project) )
          project.versions.each do |version|
            user_tasks = UserTasks.new( user, version )
            version.fixed_issues.each do |issue|
              user_tasks.add issue
            end
            events.push( user_tasks ) unless user_tasks.empty?
          end
        end
      end
    end

    from_date = Date.today - 15
    months = from_date.month == Date.today.month ? 3 : 4 
    @gantt = UserTaskGantt.new(:months=>4, :year=>from_date.year, :month=>from_date.month, :months=>months)
    @gantt.events = events.sort
  end
end
