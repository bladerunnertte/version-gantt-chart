module VersionGanttChartHelper
  def link_to_usertask( usertask )
    link_text = ""
    link_text << "#{link_to_project(usertask.version.project)} - " if usertask.version.kind_of?(BlankVersion)
    link_text << "#{link_to_version_unless_nil(usertask.version)}"
    link_text << "<br>"
    link_text << link_to_usertask_issues( usertask )
  end

  def link_to_usertask_issues( usertask )
    link_params = {:controller => 'issues',
                  :action => 'index',
                  :project_id => usertask.version.project.id,
                  :set_filter => 1,
                  :fields => usertask.filter_fields,
                  :operators => usertask.filter_operators,
                  :values => usertask.filter_values }

    link_text = ""

    if usertask.closed_issue_count > 0 
      closed_issue_text = " #{l(:label_closed_issues)}(#{usertask.closed_issue_count})"
      link_params[:operators]["status_id"] = "c"
      link_text << " #{link_to(closed_issue_text, link_params)}"
    end

    if usertask.open_issue_count > 0
      open_issue_text = " #{l(:label_open_issues)}(#{usertask.open_issue_count})"
      link_params[:operators]["status_id"] = "o"
      link_text << " #{link_to(open_issue_text, link_params)}"
    end

    return link_text
  end

  def red_label( label_text )
     '<FONT COLOR="#FF0000">'+l(label_text)+'</FONT>'
  end

  def link_to_user_unless_nil( user )
    if user == nil
      return red_label(:unassigned)
    elsif user.kind_of? User
      return link_to_user(user)
    else
      return h( user.to_s )
    end
  end

  def display_name( user )
    if user == nil #未設定時
      return red_label(:unassigned)
    else
      return h( user.to_s )
    end
  end

  def link_to_version_unless_nil( version )
    version == nil ? red_label(:unassigned) : link_to_version(version)
  end

  def link_to_project( project )
    link_to(h(project.name),{:controller=>'projects',:action=>'show',:id=>project})
  end

  def days_to_width( days,zoom,percent=100 )
    (days*zoom*percent/100).floor - 2 #- 2 for left and right borders
  end
end
