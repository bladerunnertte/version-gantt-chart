class UserTaskGantt < Redmine::Helpers::Gantt
  def events=(e)
    #eventsの開始日でのソートをオーバライドしてキャンセル

    #残作業がなく(close or 100%完了)、期日がガントの表示開始日より古いタスクは取り除く
    e.delete_if{|i| i.finished? && too_old?(i) }

    #最遅開始日がガントの表示終了日より未来のタスクは取り除く
    e.delete_if{|i| too_far_future?(i) }
    
    @events = e
  end


  def too_old?( task )
    return task.due_date < @date_from
  end
  private :too_old?

  def too_far_future?( task )
    return task.start_date > @date_to
  end
  private :too_far_future?
end

