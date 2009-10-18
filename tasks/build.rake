require 'rake/clean'
require 'tasks/build_task'

BuildTask.new('haml', 'html')
BuildTask.new('sass', 'css')

CLEAN.include('.sass-cache')

