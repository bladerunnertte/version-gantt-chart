class UserTasks
  attr_reader :user, :version

  def initialize( user, version )
    @user = user
    @version = version
    @task_info_collector = TaskInfoCollector.new
    @empty = true
  end

  def empty?
    return @empty
  end

  def finished?
    return @task_info_collector.remain_estimated_hours == 0
  end

  #集計対象のチケットを登録
  def add( issue )
    #バージョン未設定で終了済みのチケットは集計対象から外す
    if issue.fixed_version == nil && issue.closed?
      return
    end

    #ユーザとバージョンが一致するチケットを集計対象として登録する
    if( @user == issue.assigned_to && @version == issue.fixed_version )
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

  #完了予想日
  def able_day
    return Date.today + @task_info_collector.remain_estimated_days - 1 #-1は今日の作業分の調整
  end

  #超過日数
  def over_days
    return @task_info_collector.over_days
  end

  #比較メソッド（ソート用）
  def <=>(other)
    compared_result = @user.name <=> other.user.name
    if compared_result == 0
      compared_result = due_date <=> other.due_date
    end
    if compared_result == 0
      compared_result = start_date <=> other.start_date
    end
    return compared_result
  end

  #チケット数
  def count_issues
    return @task_info_collector.count_of_added
  end
end
