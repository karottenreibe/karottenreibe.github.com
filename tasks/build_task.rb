require 'rake'

class BuildTask

    def initialize( source, target, interpreter = source )
        source_files = FileList["**/*.#{source}"].exclude('_site')

        desc('build all')
        task :build => "build:#{source}"

        desc("build all #{source} files")
        task "build:#{source}" do
            source_files.each do |source_file|
                sh "#{interpreter} #{source_file} #{source_file.ext(target)}"
            end
        end
    end

end

