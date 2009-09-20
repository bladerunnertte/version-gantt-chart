require 'redmine'

Redmine::Plugin.register :redmine_version_gantt_chart do
  name 'Redmine Version Gantt Chart plugin'
  author 'Yugo Hasegawa'
  description '作業者ごとバージョンごとに進捗状況をガントチャート風に表示するプラグインです'
  version '0.0.1'
  menu :application_menu, :version_gantt_chart, {:controller => 'version_gantt_chart', :action => 'index'}, :caption => 'バージョンガントチャート', :last => true
end
