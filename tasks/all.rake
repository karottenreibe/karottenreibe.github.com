
desc('claens, builds and starts a server')
task :all => %w{clean build urlecho jekyll:server}

task :urlecho do
  puts 'http://localhost:4000'
end

