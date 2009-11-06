require 'redmine'

Redmine::Plugin.register :redmine_version_gantt_chart do
  name 'Redmine Version Gantt Chart plugin'
  author 'Yugo Hasegawa'
  description 'This plugin displays workload and progress of version.'
  version '0.3'
  menu :top_menu, :version_gantt_chart, {:controller => 'version_gantt_chart', :action => 'index'}, :caption => :label_menu, :last => true
end
