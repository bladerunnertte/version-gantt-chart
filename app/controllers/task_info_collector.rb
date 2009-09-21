class TaskInfoCollector
  WORKABLE_HOUR_A_DAY = 6
  def initialize
    @estimated_hours = 0
    @complete_hours = 0
    @done_hours = 0
    @complete_over_hours = 0
    @done_over_hours = 0
  end
  
  def add( issue )
    add_estimated_hours issue.estimated_hours

    if issue.closed?
      add_complete_hours issue.estimated_hours
      add_complete_over_hours issue.spent_hours - issue.estimated_hours
    else
      done_ratio = issue.done_ratio / 100.0
      add_done_hours( issue.estimated_hours *  done_ratio )
      add_done_over_hours( issue.spent_hours - (issue.estimated_hours * done_ratio) )
    end
  end

  def estimated_days
    estimated_days = @estimated_hours / WORKABLE_HOUR_A_DAY
    return estimated_days.ceil
  end
  
  def remain_estimated_days
    remain_hours = @estimated_hours - @complete_hours - @done_hours
    remain_estimated_days = remain_hours / WORKABLE_HOUR_A_DAY
    return remain_estimated_days.ceil
  end

  def over_days
    over_days = ( @complete_over_hours + @done_over_hours ) /  WORKABLE_HOUR_A_DAY
    return over_days.ceil
  end

  def complete_percent
     return ratio_to_percent(@complete_hours / @estimated_hours)
  end
  
  def done_percent
     return ratio_to_percent(@done_hours / @estimated_hours)
  end

  def add_estimated_hours( new_hours )
    @estimated_hours += new_hours
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
