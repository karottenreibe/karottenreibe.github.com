---
layout: post
summary:
    Advancing further and further, obstacles
    soon start to present themselves.
title: 'Ruby C Extensions Part 3: Directory Structure and extconf.rb'
---

This is part 3 of my little adventures
in Ruby C extension land.

If you haven't read part 1 and 2,
[you might want to go back there][part1].


# JustDoIt Alley #

So this was the path I chose. Maybe not the wisest
choice, but most certainly the a wild ride.

The first thing I wondered when walking down the
dark, moonlit alley was where to even begin with
putting my C files. I had vaguely heard of the
ominous ` ext ` directory, but nothing specific
about the directory structure.

Nor did I know if my Ruby files would have to
move as well and whether or not I needed some
special setup to make the gems work.

So I was pretty lost. And that after only
walking 5 steps. But that's what JustDoIt Alley
is: one big maze.


# Structure Emerging from Chaos #

After reviewing my steady companion (the broad
band internet access, remember?), I came up
with some answers:

1.  There really is a ` ext ` directory
2.  That's where your C files go
3.  Your Ruby stuff stays put
4.  There is a magic file you need to create
    in order to make things work: ` extconf.rb `

But let me clarify:


## ext ##

You will be hosting all your C code here. But
beware: for each .so/.dll file you want to create
you must have a separate sub-directory. So if
you want to have ` cranberry.so `, create
` ext/cranberry ` and put all your C code there.


## extconf.rb ##

This is the high priest of Ruby C. It knows all
and it rules all, yet it is simple and humble --
sort of like a buddhist monk.

It's the gate-keeper for the compilation process
since it's used to create the Makefile. (If you
don't know what a Makefile is:
[It's a configuration file for make][makefile])

Writing extconfs can be both: easy and terribly
complicated.
[There is limited][extconf]
[documentation on the subject][mkmf]
available online.

(**NOTE**: You could also use [mkrf][], which
will generate Rakefiles instead of Makefiles)

If you want complicated: Read the documentation.
But most of the time, easy will totally suffice,
so here is all you need to put in your extconf.rb:

{% highlight ruby %}
require 'mkmf'

extension_name = 'cranberry'
dir_config(extension_name)
create_makefile(extension_name)
{% endhighlight %}

Just replace the cranberry with the juicy name
you gave the ext directory above.

And that's it! Well -- at least for extconf.
Now while you contemplate on my brilliant
metaphor of the buddhist monk, I'll prepare
the next part of this fantastic story.


[Continue with Part 4!][part4]


[part1]:        ../../18/ruby-c-extension                                                                                                       "Part 1 of this series"
[part4]:        ../../22/ruby-c-extension-4                                                                                                     "Part 4 of this series"
[makefile]:     http://en.wikipedia.org/wiki/Makefile#Makefile_structure                                                                        "An explanation of what make is"
[extconf]:      http://www.linuxtopia.org/online_books/programming_books/ruby_tutorial/Extending_Ruby_Creating_a_Makefile_with_extconf.rb.html  "Small extconf tutorial"
[mkmf]:         http://www.ruby-doc.org/stdlib/libdoc/mkmf/rdoc/index.html                                                                      "RDoc for extconf"
[mkrf]:         http://glu.ttono.us/articles/2006/06/28/mkrf-0-1-0-released                                                                     "A quick mkrf example"

