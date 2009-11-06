module VersionGanttChartHelper
  def link_to_usertask( usertask )
    link_text = "#{link_to_version_unless_nil(usertask.version)}"
    link_text << " - "
    link_text << "#{link_to_project(usertask.version.project)}"
    link_text << "(#{usertask.count_issues.to_s})"
  end
end
