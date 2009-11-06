class TaskInfoCollector
  WORKABLE_HOUR_A_DAY = 6
  DEFAULT_ESTIMATED_HOURS = 6

  attr_reader :closed_issue_count
  attr_reader :open_issue_count

  def initialize
    @estimated_hours = 0
    @complete_hours = 0
    @done_hours = 0
    @complete_over_hours = 0
    @done_over_hours = 0
    @closed_issue_count = 0
    @open_issue_count = 0
  end
  
  def add( issue )
    add_estimated_hours estimated_hours_of(issue)

    if issue.closed?
      @closed_issue_count += 1
      add_complete_hours estimated_hours_of(issue)
      add_complete_over_hours spent_hours_of(issue) - estimated_hours_of(issue)
    else
      @open_issue_count += 1
      add_done_hours( done_hours_of(issue) )
      add_done_over_hours( spent_hours_of(issue) - done_hours_of(issue) )
    end
  end

  def estimated_days
    estimated_days = @estimated_hours / WORKABLE_HOUR_A_DAY
    return estimated_days.ceil
  end
  
  def remain_estimated_hours
    return @estimated_hours - @complete_hours - @done_hours
  end

  def remain_estimated_days
    remain_estimated_days = remain_estimated_hours / WORKABLE_HOUR_A_DAY
    return remain_estimated_days.ceil
  end

  def over_days
    over_days = ( @complete_over_hours + @done_over_hours ) /  WORKABLE_HOUR_A_DAY
    return over_days.ceil
  end

  def complete_percent
    return ratio_to_percent( divide_by_estimated_hours(@complete_hours))
  end
  
  def done_percent
    return ratio_to_percent( divide_by_estimated_hours(@done_hours))
  end

private
  def spent_hours_of( issue )
    if issue.spent_hours
      return issue.spent_hours
    else
      return 0 
    end
  end

  def estimated_hours_of( issue )
    if issue.estimated_hours
      return issue.estimated_hours
    else
      return DEFAULT_ESTIMATED_HOURS 
    end
  end
  
  def done_hours_of( issue )
    return 0 unless issue.done_ratio
    return estimated_hours_of( issue ) * issue.done_ratio / 100.0
  end

  def divide_by_estimated_hours( target_hours )
    return 1.0 if @estimated_hours == 0
    return target_hours / @estimated_hours
  end

  def add_estimated_hours( new_hours )
    @estimated_hours += new_hours if new_hours
  end

  def add_complete_hours( new_hours )
    @complete_hours += new_hours
  end

  def add_done_hours( new_hours )
    @done_hours += new_hours
  end

  def add_complete_over_hours( new_hours )
    @complete_over_hours += new_hours
  end
  
  def add_done_over_hours( new_hours )
    @done_over_hours += new_hours
  end

  def ratio_to_percent( ratio )
     percent = ratio * 100
     return percent.round
  end
end
