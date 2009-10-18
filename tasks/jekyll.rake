require 'rake/clean'

desc('run jekyll')
task :jekyll do
    sh 'jekyll'
end

desc('run jekyll and launch a server on port 4000')
task "jekyll:server" do
    sh 'jekyll --server'
end

CLEAN.include('_site')

