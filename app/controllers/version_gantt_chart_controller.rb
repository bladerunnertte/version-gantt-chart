class VersionGanttChartController < ApplicationController

  def index
    #ユーザの担当するIssueをVersionごとに集める
    user_version_issue_hash = {}

    user_list = User.find(:all)
    user_list.each do |user|
      version_issue_hash = {}

      user.projects.each do |project|
        project.versions.each do |version|
          assigned_issue_list = []
          version.fixed_issues.each do |issue|
            if issue.assigned_to == user
              assigned_issue_list.push issue
            end
          end
          version_issue_hash[version] = assigned_issue_list unless assigned_issue_list.empty?
        end
      end

      user_version_issue_hash[user] = version_issue_hash unless version_issue_hash.empty?
    end

    #Versionの期日が早い順にソート
    @sorted_user_version_issue_hash =  user_version_issue_hash

  end
end
