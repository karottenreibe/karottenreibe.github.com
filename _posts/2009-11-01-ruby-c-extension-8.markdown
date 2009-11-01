---
layout: post
summary:
    In the last real part of the saga,
    I explore how to efficiently deploy
    your gems (i.e. one command does it all ;-)
title: 'Ruby C Extensions Part 8: Deployment'
---

This is part 8 of the tale of my adventures
in Ruby C extension land.

If you haven't read the other parts,
[you might want to go back there][part1].


# Deployment City #

And there I was. Having escaped the
clutches of the evil wizard by taunting
him with my [rake-tester][] until
he weeped, I was now facing the
town of Deployment City, the capital
of Ruby C extension land.

And my greatest challenge was yet to
come.


# Deploying Native Gems #

When you write native gems, you are
faced with a tough question:

> Will I compile for all systems or
> will I compile only for a selected
> elite?

That is, will you make a distinct gem for every
Ruby platform or will you make a general gem
that contains only the instructions on how to
compile and only distribute native pre-compiled
versions for some selected platform(s)?


## The Compile-It-Yourself Version ##

This is of course the easy version...
Just

    rake build

or

    rake gem

a gem that contains the ` ext ` directory
with all your source files and you're
done.

When you install that gem and
[you configured your gemspec correctly][jeweler-interlude]
and set up your gemspec with

    gemspec.extension = FileList['ext/cranberry/extconf.rb']

there should be no problems and Ruby should
show the well-known

    Building native extensions.  This could take a while...

screen and your build should succeed.

You can distribute this gem as the
` cranberry-0.0.1.gem ` file.

Should you choose to also provide custom
pre-compiled versions, Rubygems will
automatically pick the pre-compiled ones
when applicable.


## Pre-Compiled Fixxer-Upper ##

Before we can start to produce gems that
do not need to be built by the end user
(pre-compiled ones, that is), we need
to fix something:

{% highlight ruby %}
task :native => :no_extconf

task :no_extconf do
    $gemspec.extensions = []
end
{% endhighlight %}

This ensures that there are no ` extconf.rb `
files registered with the gemspec when
building native gems (both for your
system and for cross-compilation).


## The Pre-Compiled-Niceness Version ##

Especially for [Windows folks][linus] it
is always nice if you provide precompiled
binaries (they don't like compilers very
much and compilers don't like them either).

So here's how you do it for your platform
(i.e. the OS you're running):

First, run either of the commands below,
depending on your gemspec manager:

    rake clean native build
    rake clean native gem

This will produce a file similar to
` pkg/cranberry-0.0.1.gem ` which you
will have to rename to whatever platform
you run:

*   ` cranberry-0.0.1-i686-linux.gem ` for Linux
    (it took me quite some googling to figure this
    one out. All other variants, e.g. ` x86-linux `
    don't work)
*   ` cranberry-0.0.1-x86-mingw32.gem ` for Windows
    if you compiled using mingw (everything else
    is insane anyways ;-)
*   Don't know what's the right name for the big
    Apple... if you do, let me know!


## The Crossing-Dressed Version ##

If you're sitting on a Linux box, you can of
course cross-compile for MS's Win 32,
[if you configured rake-compiler correctly][rake-compiler].

The procedure is similar to above, but you have
to call

    rake clean cross build

or

    rake clean cross gem

instead.

The renaming is the same.


# Automated Build-Em-All Version #

If you're like me, you'll want all of the
above -- and you'll want it done with a
single command:

    rake gems

Hehe...

Here's the Rake setup to do it:

{% highlight ruby %}
desc("Build linux and windows specific gems")
task :gems do
    sh "rake clean build:native"
    sh "rake clean build:cross"
    sh "rake clean build"
end

task "build:native" => [:no_extconf, :native, :build] do
    file = "pkg/cranberry-#{get_version}.gem"
    mv file, "#{file.ext}-i686-linux.gem"
end

task "build:cross" => [:no_extconf, :cross, :native, :build] do
    file = "pkg/cranberry-#{get_version}.gem"
    mv file, "#{file.ext}-x86-mingw32.gem"
end

task :no_extconf do
    $gemspec.extensions = []
end

def get_version
    `cat VERSION`.chomp
end
{% endhighlight %}

Please note though, the ` get_version ` function
is Jeweler specific. If you use some other
gemspec manager, you'll need to adjust it
to return the version of the gem to be built
as a String (e.g. ` $gemspec.version.to_s `).

So, this is the last exhaustingly long post
about Ruby C extensions.

I decided to write a (probably even longer)
wrapup article using [Joker][] as an example
to demonstrate it all in shorter and and
with *real* code as the basis.


And by the way: C extension land rocks! ;-)

Hope it helped!


[part1]:                ../../../10/18/ruby-c-extension                     "Part 1 of this series"
[rake-tester]:          http://www.github.com/karottenreibe/rake-tester     "Tests your C code using a C testing framework"
[jeweler-interlude]:    ../../../10/25/jeweler-interlude                    "How to configure Jeweler for C extension deployment"
[rake-compiler]:        http://github.com/luislavena/rake-compiler          "rake-comiler -- The compiler genie that will grant all your wishes"
[joker]:                http://karottenreibe.github.com/joker               "Joker -- A Ruby library for Wildcard matching"
[linus]:                

