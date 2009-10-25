---
layout: post
summary:
    A little interlude about how to mix
    Jeweler and rake-compiler.
title: Jeweler - rake-compiler Interlude
---

# Ruby C Extensions #

Lately I have been
[going on about how to write Ruby C Extensions][cextensions]
and I thought at this point I should share with
you how to wire my favourite Gem manager [Jeweler][]
and the famous [rake-compiler][] together to make
Ruby C extension development easier.


# Jeweler Setup #

You will need to configure Jeweler for four things:

1.  Setting up the extensions flag of the gemspec
2.  Including the generated native files
3.  Storage of the generated gemspec
4.  Generating a gemspec before each build

Let's look at each in turn:


## The Extensions Flag ##

{% highlight ruby %}
Jeweler::Tasks.new do |gem|
    ...
    gem.extensions = FileList['ext/**/extconf.rb']
end
{% endhighlight %}

This will enable you to package a gem for all
the platforms that you don't provide a native
binary for. This gem will perform the well known

    Building native extensions.  This could take a while...

task on installation.


## Including the Binaries ##

{% highlight ruby %}
Jeweler::Tasks.new do |gem|
    ...
    gem.files.include('lib/cranberry.*')
end
{% endhighlight %}

This will include all generated ` canberry.so `
or ` cranberry.dll ` and so on in your generated
gem.


## Storing the GemSpec ##

Since rake-compiler needs the gemspec on initialization,
we need to store it:

{% highlight ruby %}
jeweler_tasks = Jeweler::Tasks.new do |gem|
    ...
end
$gemspec = jeweler_tasks.gemspec
{% endhighlight %}

This also means that rake-compiler tasks must be set up
after the Jeweler tasks.


## Fixing the GemSpec Version ##

(**UPDATE:** This is a simpler solution. The one posted
previously works as well, but this is less invasive)

{% highlight ruby %}
$gemspec.version = jeweler_tasks.jeweler.version
{% endhighlight %}

This fixes an issue in the interaction of rake-compiler
and Jeweler. Rake-compiler needs the gemspec to have a
version, but Jeweler will only store the current version
in the gemspec if certain tasks are called, e.g.
` gemspec `.

If not applied, native building will fail with

    Version required (or :noversion)


# Rake-Compiler Setup #

The rake-compiler itself doesn't need any special
configuration, except for passing in the gemspec:

{% highlight ruby %}
Rake::ExtensionTask.new('craberry', $gemspec) do
    ...
end
{% endhighlight %}

But there are some bugs when wiring
it to Jeweler.


## Gemspec Marshalling Fix ##

{% highlight ruby %}
Rake::Task.tasks.each do |task_name|
    case task_name.to_s
    when /^native/
        task_name.prerequisites.unshift("fix_rake_compiler_gemspec_dump")
    end
end

task :fix_rake_compiler_gemspec_dump do
    %w{files extra_rdoc_files test_files}.each do |accessor|
        $gemspec.send(accessor).instance_eval {
            @exclude_procs = Array.new
        }
    end
end
{% endhighlight %}

This forces Rake to always execute
` fix_rake_compiler_gemspec_dump ` before
invoking any ` native ` tasks.

Rake-compiler at one point needs to draw a copy of
the gemspec. But since gemspecs don't have a ` dup `
method, it resorts to YAML-dump-loading the whole
thing.

But when using Jeweler, the gemspec will have some
Procs attached (to the FileLists), which can't be
YAML-loaded (there's no dumping of Ruby code),
so the gemspec cloning will fail with

    allocator undefined for Proc

The above code snippet prevents that by removing
those Procs before the YAML dumping.


# The Rest #

For the rest, you can
[follow the rake-compiler tutorial][rake-compiler]
except that with Jeweler the ` gem ` task is
called ` build `.

Hope this helps some folks out there!


[cextensions]:  ../../18/ruby-c-extension/     "Part 1 of the C Extension series"
[jeweler]:      http://github.com/technicalpickles/jeweler  "Jeweler - a gemspec manager"
[rake-compiler]: http://rake-compiler.rubyforge.org/     "The rake-compiler project"

