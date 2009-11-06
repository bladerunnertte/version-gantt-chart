class TaskInfoCollector
  WORKABLE_HOUR_A_DAY = 6
  DEFAULT_ESTIMATED_HOURS = 6

  attr_reader :count_of_added

  def initialize
    @estimated_hours = 0
    @complete_hours = 0
    @done_hours = 0
    @complete_over_hours = 0
    @done_over_hours = 0
    @count_of_added = 0
  end

  def estimated_hours_of( issue )
    if issue.estimated_hours
      return issue.estimated_hours
    else
      return DEFAULT_ESTIMATED_HOURS 
    end
  end
  private :estimated_hours_of
  
  def done_hours_of( issue )
    return 0 unless issue.done_ratio
    return estimated_hours_of( issue ) * issue.done_ratio / 100.0
  end
  private :done_hours_of
  
  def add( issue )
    @count_of_added += 1

    issue.spent_hours = 0 unless issue.spent_hours
    add_estimated_hours estimated_hours_of(issue)

    if issue.closed?
      add_complete_hours issue.estimated_hours
      add_complete_over_hours issue.spent_hours - issue.estimated_hours
    else
      add_done_hours( done_hours_of(issue) )
      add_done_over_hours( issue.spent_hours - done_hours_of(issue) )
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

  def divide_by_estimated_hours( target_hours )
    return 1.0 if @estimated_hours == 0
    return target_hours / @estimated_hours
  end
  private :divide_by_estimated_hours

  def add_estimated_hours( new_hours )
    @estimated_hours += new_hours if new_hours
  end
  private :add_estimated_hours

  def add_complete_hours( new_hours )
    @complete_hours += new_hours
  end
  private :add_complete_hours

  def add_done_hours( new_hours )
    @done_hours += new_hours
  end
  private :add_done_hours

  def add_complete_over_hours( new_hours )
    @complete_over_hours += new_hours
  end
  private :add_complete_over_hours
  
  def add_done_over_hours( new_hours )
    @done_over_hours += new_hours
  end
  private :add_done_over_hours

  def ratio_to_percent( ratio )
     percent = ratio * 100
     return percent.round
  end
  private :ratio_to_percent
end
