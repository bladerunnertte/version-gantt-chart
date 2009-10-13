class BlankVersion
  attr_reader :project

  def initialize( project )
    @project = project
  end

  def ==(other)
    if equal?(other)
      return true 
    elsif other.nil?
      return true
    else
      return false
    end
  end

  def due_date
    return nil
  end

  def fixed_issues
    issues_list = []
    @project.issues.each do |issue|
      issues_list.push(issue) unless issue.fixed_version
    end
    return issues_list
  end

end
