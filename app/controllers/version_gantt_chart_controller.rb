require 'user_tasks'

class VersionGanttChartController < ApplicationController

  def index
    #ユーザごとのタスク情報を集める
    @user_tasks_list = []

    user_list = User.find(:all)
    user_list.each do |user|
      user_tasks = UserTasks.new( user )

      user.projects.each do |project|
        project.versions.each do |version|
          version.fixed_issues.each do |issue|
            user_tasks.add issue
          end
        end
      end

      @user_tasks_list.push( user_tasks ) unless user_tasks.empty?
    end
  end
end
