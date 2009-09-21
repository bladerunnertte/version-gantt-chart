class UserTasks
  attr_reader :user
  attr_reader :version_list

  def initialize( user )
    @user = user
    @version_task_hash = {}
    @version_list = []
  end

  def empty?
    @version_task_hash.empty?
  end

  def add( issue )
    if( issue.assigned_to == @user )
      add_task_by_version( issue )
    end
  end

  def add_task_by_version( issue )
    unless @version_task_hash[issue.fixed_version]
      @version_task_hash[issue.fixed_version] = TaskInfoCollector.new
      @version_list.push( issue.fixed_version )
    end

     @version_task_hash[issue.fixed_version].add( issue )
  end
  private :add_task_by_version

  #最遅開始日
  def latest_start_day( version )
    return version.due_date - @version_task_hash[version].estimated_days + 1 #+1は期日当日分の調整
  end

  #バージョンの予定工数のうち終了の割合
  def complete_percent( version )
    return @version_task_hash[version].complete_percent
  end

  #バージョンの予定工数のうち作業済みの割合（終了状態を除いて）
  def done_percent( version )
    return @version_task_hash[version].done_percent
  end

  #完了予想日
  def able_day( version )
    return Date.today + @version_task_hash[version].remain_estimated_days - 1 #-1は今日の作業分の調整
  end

  #超過日数
  def over_days( version )
    return @version_task_hash[version].over_days
  end
end
