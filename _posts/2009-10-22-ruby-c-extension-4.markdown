---
layout: post
summary:
    Our hero finds a useful companion
    after having escaped the first
    part of the wild maze he got himself
    into last time.
title: Ruby C Extensions -- Part 4
---

This is part 4 of my exploits
in Ruby C extension land.

If you haven't read part 1, 2 and 3,
[you might want to go back there][part1].


# A Fearless Companion #

After having surmounted the first obstacles,
I found myself facing a small cottage that
turned out to be inhabited by a nice young
fellow, called [Luis][].

I told him my story and that I wanted to
seek the miracles of this magic land and
he empathized with me.

Being totally enchanted by my tale, he
agreed to lend me his mighty steed for
my exploits.

It's name was rake-compiler.


## Configuration ##

When using the steed -- I mean
rake-compiler -- there are some simple
steps you need to take.

First, you must modify your Rakefile:

{% highlight ruby %}
require 'rake/extensiontask'
Rake::ExtensionTask.new('cranberry', $gemspec)
{% endhighlight %}

Just replace ` cranberry ` with the name of the
ext directory from the last part.

` $gemspec ` must refer to your gem specification.
There are numerous tools out there, but I
like [Jeweler][], because it integrates
with [Git][].

(**NOTE:** I'll write an
[extra article on integrating Jeweler and rake-compiler][jew-rakec]
.)

Once you have done that, there are several
new tasks available for you:

{% highlight sh %}
rake compile                # compile all defined extensions
rake compile:cranberry      # compile the cranberry extension
rake native                 # prepare for native gem build
{% endhighlight %}

The last one can be used like one of the
following:

{% highlight sh %}
rake native gem
rake native build
{% endhighlight %}

depending on your rake configuration
(for jeweller it's the last one).


## Ready, Set, Compile! ##

Now you're ready to compile some C!
Just put some example C code in the
appropriate ` ext ` directory and run
the above tasks.

While you do that, I'll go off and ponder
on what to tell you next.


[part1]:        ../../18/ruby-c-extension  "Part 1 of this series"
[jeweler]:      http://github.com/technicalpickles/jeweler      "Jeweler, which manages your gemspec"
[git]:          http://whygitisbetterthanx.com/     "The only true version control system :-)"
[luis]:         http://github.com/luislavena    "The great fellow who created rake-compiler"
[jew-rakec]:    ../../25/jeweler-interlude      "How to mix Jeweler and rake-compiler"

