---
layout: post
summary:
    This time, an evil wizard forces me to
    write tests for my code, which leads to
    a nice invention.
title: 'Ruby C Extensions Part 7: Testing'
---

This is part 7 of the tale of my adventures
in Ruby C extension land.

If you haven't read the other parts,
[you might want to go back there][part1].


# The Tower #

As is inevitable in any good story, an evil wizard
living in a tower has to occurr at some point.

That point is now.

It's a mean old wizard with a lizard on his shoulder
[wearing a monocle][urealms] and a robe.

You better watch out, because he's going to curse you
like he did to me.


# The Testing Curse #

So you wrote your C code and now you have to test it
because the wizard forces you to.

No of course not.. You have of course written the tests
in advance, haven't you? ;-)

Now, there are two ways to test your C code:

1.  Test it using Ruby
2.  Test it in C


## Ruby Tests ##

These are the simple ones. Just wrap your functions
and data structures in Ruby objects and write your
unit tests, voila!

But you don't want to expose any of your internal
structs and functions to normal Ruby code? Well,
so did I. So I invented a little helper to work
around that.


## C Tests ##

Testing your C functions in C is pretty easy, once
you've installed the [rake-tester][]. It will take
care of compilation and execution of your C tests
while still leaving you the choice of the testing
framework (e.g. [cmockery][]).

To set it up, change your Rakefile as follows:

{% highlight ruby %}
require 'rake/extensiontask'
require 'rake/extensiontesttask'

Rake::ExtensionTask.new('cranberry', $gemspec) do |ext|
    # ...normal options...
    ext.test_files = FileList['test/c/*']
end
{% endhighlight %}

Just point ` test_files ` to all the C files that
contain your tests.

Rake-tester will automatically link them against
your native code and compile them with debugging
symbols.

Now you can execute

    rake test:c

to re-compile and start all your tests.


### Additional Features ###

Furthermore, rake-tester offers [gdb][] and
[valgrind][] integration:

    rake test:gdb:cranberry[test]
    rake test:valgrind:cranberry[test]

Just replace ` test ` with the test you want
to execute. For example, if you have a file
called ` test_allocation.c ` then you can
start valgrind on that test suite with

    rake test:valgrind:cranberry[test_allocation]

This made my life much easier. I hope it helps
you as well.

Now go and write good tests for your C code
and get rid of all those memory leaks.

I'll think hard about the next part, which
might already be the last one about C extensions...


[part1]:        ../../18/ruby-c-extension                                       "Part 1 of this series"
[urealms]:      http://www.escapistmagazine.com/videos/view/unforgotten-realms  "It's a well known fact that all wizards wear monocles."
[rake-tester]:  http://www.github.com/karottenreibe/rake-tester                 "Tests your C code using a C testing framework"
[cmockery]:     http://code.google.com/p/cmockery/                              "Testing framework for C"
[gdb]:          http://www.gnu.org/software/gdb/                                "Debugging C code is like touching a hot plate: It hurts!"
[valgrind]:     http://valgrind.org/                                            "The greatest invention since sliced pointers...ah...I mean bread."

