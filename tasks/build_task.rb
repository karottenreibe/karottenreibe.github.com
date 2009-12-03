require 'rake'

class BuildTask

    def initialize( source, target, interpreter = source )
        @target = target
        source_files = FileList["**/.*.#{source}"].exclude('_site')

        desc('build all')
        task :build => "build:#{source}"

        desc("build all #{source} files")
        task "build:#{source}" do
            source_files.each do |source_file|
                target_file = source_to_target(source_file)
                sh "#{interpreter} #{source_file} #{target_file}" if newer_than(source_file, target_file)
            end
        end
    end

    def source_to_target( source_file )
        basename = File.basename(source_file)[1..-1]
        dirname  = File.dirname(source_file)
        File.join(dirname, basename).ext(@target)
    end

    def newer_than( source, target )
        File.mtime(source) > File.mtime(target)
    end

end

