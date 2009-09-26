require 'user_tasks'
require 'without_events_sort_gantt'

class VersionGanttChartController < ApplicationController
  unloadable

  def index
    events = []

    user_list = User.find(:all)
    user_list.each do |user|
      user.projects.each do |project|
        project.versions.each do |version|
          user_tasks = UserTasks.new( user, version )
          version.fixed_issues.each do |issue|
            user_tasks.add issue
          end
          events.push( user_tasks ) unless user_tasks.empty?
        end
      end
    end

    @gantt = WithoutEventsSortGantt.new
    @gantt.events = events.sort
  end
end
