module VersionGanttChartHelper
  def link_to_usertask( usertask )
    link_text = "#{link_to_version_unless_nil(usertask.version)}"
    link_text << " - "
    link_text << "#{link_to_project(usertask.version.project)}"
    link_text << link_to_usertask_issues( usertask )
  end

  def link_to_usertask_issues( usertask )
    count_of_issues = "(#{usertask.count_issues.to_s})"
    link_params = {:controller => 'issues',
                  :action => 'index',
                  :project_id => usertask.version.project.id,
                  :set_filter => 1,
                  :fields => usertask.filter_fields,
                  :operators => usertask.filter_operators,
                  :values => usertask.filter_values }
    link_text = " #{link_to( count_of_issues, link_params)}"
  end
end
