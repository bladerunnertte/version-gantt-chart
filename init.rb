require 'redmine'

Redmine::Plugin.register :redmine_version_gantt_chart do
  name 'Redmine Version Gantt Chart plugin'
  author 'Yugo Hasegawa'
  description '作業者ごとバージョンごとに進捗状況をガントチャート風に表示するプラグインです'
  version '0.0.1'
end
