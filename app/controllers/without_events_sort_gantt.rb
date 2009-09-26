#eventsが開始日でソートされないようにオーバライド
class WithoutEventsSortGantt < Redmine::Helpers::Gantt
  def events=(e)
    @events = e
  end
end

