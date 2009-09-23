class UserTasks
  attr_reader :user
  attr_reader :version

  def initialize( user, version )
    @user = user
    @version = version
    @task_info_collector = TaskInfoCollector.new
    @empty = true
  end

  def empty?
    return @empty
  end

  #集計対象のチケットを登録
  def add( issue )
    if( issue.assigned_to == @user && issue.fixed_version == @version )
      @empty = false
      @task_info_collector.add(issue)
    end
  end

  #最遅開始日
  def start_date
    return due_date - @task_info_collector.estimated_days + 1 #+1は期日当日分の調整
  end

  #期日
  def due_date
    return @version.due_date ? @version.due_date : Date.today - 1 #期日未設定時は超過で表示して目立たせる
  end

  #バージョンの予定工数のうち終了の割合
  def complete_percent
    return @task_info_collector.complete_percent
  end

  #バージョンの予定工数のうち作業済みの割合（終了状態を除いて）
  def done_percent
    return @task_info_collector.done_percent
  end

  def done_date
    return start_date + ((due_date - start_date + 1)*(complete_percent+done_percent)/100).floor
  end

  #完了予想日
  def able_day
    return Date.today + @task_info_collector.remain_estimated_days - 1 #-1は今日の作業分の調整
  end

  #超過日数
  def over_days
    return @task_info_collector.over_days
  end
end
