---
layout: post
summary:
    This time it's all about the definition
    of C functions that map to Ruby functions
    and argument checking in C.
title: Ruby C Extensions -- Part 6
---

This is part 6 of the tale of my adventures
in Ruby C extension land.

If you haven't read the other parts,
[you might want to go back there][part1].


# Defining Functions #

In the last part, I showed how to define
the two function types:

*   Fixed argument count
*   Variable argument count

Here's how to implement the according C
functions:

## Fixed Argument Count ##

{% highlight c %}
VALUE juice(self, argument1, argument2)
    VALUE self;
    VALUE argument1;
    VALUE argument2;
{
    // ...
}
{% endhighlight %}

` self ` will point to the Ruby object this
function is a member of, e.g. ` Cranberry `
if you called it as ` Cranberry.juice `.

The other arguments will be just that --
the function's arguments.

Ruby will ensure you always get the right
amount of arguments.


## Variable Argument Count 1 -- C Array ##

{% highlight c %}
VALUE new(argc, argv, self)
    int      argc;
    VALUE *  argv;
    VALUE    self;
{
    // ...
}
{% endhighlight %}

This one's more complex.

` argc ` will contain the number of arguments
passed to the function.
Ruby ensures you get at least the minimum
number of arguments you specified.

` argv ` will be a collection of the passed
arguments. You won't manipulate this directly.

` self ` is the same as above.


### Argument Checking ###

With this version, you will have to
explicitly retrieve the arguments from
` argv `.

For this you use ` rb_scan_args `.
It takes in ` argc `, `argv`, the number
of required and optional arguments and pointers
to the ` VALUE ` objects to fill with these
arguments:

{% highlight c %}
VALUE cranberry;
VALUE optional;
rb_scan_args(argc, argv, "11", &cranberry, &optional);
{% endhighlight %}

The nice thing about ` rb_scan_args `, though, is
that it will raise a Ruby exception when the
argument count is not as expected.

As you can see, ` "11" ` is the string that tells
` rb_scan_args ` how many arguments you expect:
one mandatory, one optional.

To further illustrate, here's a list of Ruby
definitions and their ` rb_scan_args ` equivalents:

{% highlight ruby %}
def foo( arg = nil )
rb_scan_args(argc, argv, "01", &arg);

def foo( &block )
rb_scan_args(argc, argv, "0&", &block);

def foo( *args )
rb_scan_args(argc, argv, "0*", &args);

def foo( arg, opt = nil, *args, &block )
rb_scan_args(argc, argv, "11*&", &arg, &opt, &args, &block);
{% endhighlight %}

I think you get the scheme...

Any optional arguments and the block argument
will be set to ` nil ` if they were left out.


## Variable Argument Count 2 -- Ruby Array ##

{% highlight c %}
VALUE new(self, args)
    VALUE  self;
    VALUE  args;
{
    // ...
}
{% endhighlight %}

This one's easy again: Just use ` args ` as the
Ruby array it is.


OK, now while you digest this big hunk of
information, I will dream about the next
piece of this fine saga.


[part1]:        ../../18/ruby-c-extension  "Part 1 of this series"

