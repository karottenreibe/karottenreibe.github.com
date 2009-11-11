---
layout: post
summary:
    This is a small wrapup of C extensions
    that recapitulates most of the points
    I made in the looooong posts before by
    just showing off Joker's project directory.
title: Ruby C Extension Wrapup
---

This is a wrapup of
[my C extension series of blog posts][part1].

I'm going to show the key points again
on the example of my project [Joker][].

This is inteded for all the people who
don't wanna hear the story, but rather
want a brief explanation of how the
code works.


# The Toolchain #

...consists of [Jeweler][], [rake-compiler][]
and [rake-tester][].


# The Directory Structure #

Here's an excerpt from a
` tree ` of Joker's project
directory as it's currently on my system:

    .
    |-- Rakefile
    |-- ext
    |   `-- joker_native
    |       |-- Joker.c
    |       |-- Joker.h
    |       |-- Wildcard.c
    |       |-- Wildcard.h
    |       |-- compile.c
    |       |-- compile.h
    |       |-- extconf.rb
    |       |-- match.c
    |       `-- match.h
    |-- lib
    |   `-- joker.rb
    `-- test
        |-- c
        |   |-- test_compile.c
        |   `-- test_match.c
        `-- ruby
            `-- test_joker.rb

    7 directories, 24 files

*   There is a ` Rakefile `
*   There is the usual ` lib ` dir, containing
    the Ruby code
*   There is an ` ext ` dir, containing one
    subdirectory for each native ` .so/.dll `
    file to generate
*   There is a ` test ` directory with Ruby
    and C tests


# extconf.rb #

The extconf file is pretty straight forward.
It only configures the directory of the
extension and tells mkmf to create a Makefile
for it:

{% highlight ruby %}
require 'mkmf'

extension_name = 'joker_native'
dir_config(extension_name)
create_makefile(extension_name)
{% endhighlight %}


# The Rakefile #

First we must configure Jeweler, so we
can obtain the gemspec:

{% highlight ruby %}
require 'jeweler'
jeweler_tasks = Jeweler::Tasks.new do |gem|
    gem.name                = 'joker'
    gem.summary             = 'Joker is a simple wildcard implementation that works much like Regexps'
    gem.description         = gem.summary
    gem.email               = 'karottenreibe@gmail.com'
    gem.homepage            = 'http://karottenreibe.github.com/joker'
    gem.authors             = ['Fabian Streitel']
    gem.rubyforge_project   = 'k-gems'
    gem.extensions          = FileList['ext/**/extconf.rb']

    gem.files.include('lib/joker_native.*') # add native stuff
end

$gemspec         = jeweler_tasks.gemspec
$gemspec.version = jeweler_tasks.jeweler.version

Jeweler::RubyforgeTasks.new
Jeweler::GemcutterTasks.new
{% endhighlight %}

Then, we can setup rake-compiler and
rake-tester:

{% highlight ruby %}
require 'rake/extensiontask'
require 'rake/extensiontesttask'

Rake::ExtensionTask.new('joker_native', $gemspec) do |ext|
    ext.cross_compile   = true
    ext.cross_platform  = 'x86-mswin32'
    ext.test_files      = FileList['test/c/*']
end

CLEAN.include 'lib/**/*.so'
{% endhighlight %}

And include some workarounds for nasty
problems (they might be solved some time in
the future).

{% highlight ruby %}
# Workaround for rake-compiler, which YAML-dump-loads the
# gemspec, which leads to errors since Procs can't be loaded
Rake::Task.tasks.each do |task_name|
    case task_name.to_s
    when /^native/
        task_name.prerequisites.unshift("fix_rake_compiler_gemspec_dump")
    end
end

task :fix_rake_compiler_gemspec_dump do
    %w{files extra_rdoc_files test_files}.each do |accessor|
        $gemspec.send(accessor).instance_eval { @exclude_procs = Array.new }
    end
end
{% endhighlight %}

And finally we can define some nice
shortcuts ofr the compilation process:

{% highlight ruby %}
desc("Build linux and windows specific gems")
task :gems do
    sh "rake clean build:native"
    sh "rake clean build:cross"
    sh "rake clean build"
end

task "build:native" => [:no_extconf, :native, :build] do
    file = "pkg/joker-#{`cat VERSION`.chomp}.gem"
    mv file, "#{file.ext}-i686-linux.gem"
end

task "build:cross" => [:no_extconf, :cross, :native, :build] do
    file = "pkg/joker-#{`cat VERSION`.chomp}.gem"
    mv file, "#{file.ext}-x86-mingw32.gem"
end

task :no_extconf do
    $gemspec.extensions = []
end
{% endhighlight %}


# The Workflow #

Now, you can write your C code, compile
it with

    rake compile

write some C tests and start them with

    rake test:c

or run [valgrind][] on one of the test
executables with

    rake test:valgrind:joker_native[test_compile]

or gdb it with

    rake test:gdb:joker_native[test_compile]

If you're done with writing and testing
you can build the pre-compiled stuff for
your system and the cross compilation
target platform with

    rake native build
    rake cross native build

and build the three package types
(not compiled, pre-compiled and cross-compiled)
and package them as separate gems
all with as much as

    rake gems

[part1]:            ../../18/ruby-c-extension                           "Part 1 of the C extension series"
[joker]:            http://karottenreibe.github.com/joker               "Joker -- A Ruby library for Wildcard matching"
[rake-compiler]:    http://github.com/luislavena/rake-compiler          "rake-comiler -- The compiler genie that will grant all your wishes"
[rake-tester]:      http://www.github.com/karottenreibe/rake-tester     "rake-tester -- Testing Ruby C Extensions with C frameworks"
[valgrind]:         http://valgrind.org/                                "Valgrind -- Trace down your memory leaks!"
[jeweler]:          http://github.com/technicalpickles/jeweler          "Jeweler -- a gem manager"

