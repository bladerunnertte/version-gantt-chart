class UserTaskGantt < Redmine::Helpers::Gantt
  def initialize params
    super
    @visible = params[:visible]
  end

  def events=(e)
    #eventsの開始日でのソートをオーバライドしてキャンセル

    #残作業がなく(close or 100%完了)、期日がガントの表示開始日より古いタスクは取り除く
    e.delete_if{|i| i.finished? && too_old?(i) }

    #最遅開始日がガントの表示終了日より未来のタスクは取り除く
    e.delete_if{|i| too_far_future?(i) }
    
    @events = e
  end

  def visible?(user)
    return @visible != nil && @visible.include?(user.id.to_s)
  end

private
  def too_old?( task )
    return task.due_date < @date_from
  end

  def too_far_future?( task )
    return task.start_date > @date_to
  end
end

