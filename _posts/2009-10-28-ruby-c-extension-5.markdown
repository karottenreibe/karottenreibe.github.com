---
layout: post
summary:
    Today I explore how to write your
    extension C code and how to integrate
    it with Ruby.
title: Ruby C Extensions Part 5 -- Implementation and Interfacing
---

This is part 5 of my exploits
in Ruby C extension land.

If you haven't read the previous parts,
[you might want to go back there][part1].


# Heavy Work #

To pay off for the horse, I was forced to
work in the fields for two months. Heavy
work, that is.

So will you. So better get your C manual.


# The Implementation #

Writing C for Ruby is pretty straight
forward. You don't have to worry about
interfacing with Ruby one bit when you
write the implementation Code. That can
be fitted in in 5 minutes after the actual
C Code is working.


## Ruby in C ##

But you can of course use the Ruby interface
anytime in your Code to make your life easier
-- be it when manipulating Arrays, storing
Strings etc.

[The pickaxe has a solid chapter][pickaxe] on all sorts
of useful stuff.

There also was a good post somewhere that
told people to not write C but rather "Ruby in C".
Unfortunately I've lost the link to that.

Nonetheless a good advice if you want to develop
faster. Performance optimizations can be done
later on anyways.

You can even use the ` rb_eval ` and ` rb_funcall `
to evaluate arbitrary Ruby code or call a function.


# Interfacing #

The only part where you *really* need to use the
Ruby API is when you want your C code to be accessed
by Ruby code (which at some point you will have to).

But fortunately, this is the really easy part.
All you need to do is

1.  Declare an initialization function
1.  Declare one or more classes or modules
2.  Wrap some C structs in those classes and modules
2.  Declare one or more functions
3.  Associate a real C function with the declared
    Ruby functions

All of those things are done with a single line of
code each.

Isn't that nice?


## Initialization ##

For each extension, there must be an initialization
function. The function follows a naming convention:

    void Init_<extension name>(void)

So, our ` cranberry ` extension would have to have
a ` void Init_cranberry(void) ` function in one
of the C files.

It doesn't matter where, mkmf will find it.


## Classes and Modules ##

Here's how you declare a new class/module:

{% highlight c %}
VALUE class_Cranberry;
{% endhighlight %}

Then you have to make it accessible to Ruby in
your init function:

{% highlight c %}
class_Cranberry = rb_define_class("Cranberry", rb_cObject);
{% endhighlight %}

This tells Ruby that ` class_Cranberry ` contains
the data of the Ruby class ` Cranberry `, which inherits
` Object `. (For a list of the C names of standard Ruby
classes, see the ` ruby.h ` header file.)


## Wrapping C Structs ##

You can store the data contained in a C struct inside a
Ruby object. Ruby then takes care of the lifecycle
of that struct.

Imagine you have a struct that represents the Cranberry
class in C, then to wrap a Cranberry object around it,
call

{% highlight c %}
VALUE new_object = Data_Wrap_Struct(class_Cranberry, NULL, free_Cranberry, some_struct);
{% endhighlight %}

This is typically done in allocator functions, e.g. ` new `.

` free_Cranberry ` points to a function of type
` void free_Cranberry(void*) `, which Ruby will
call when your C object must be garbage collected.
That function will get a pointer to the wrapped struct
so it can deallocate its memory.

By the way, if you want to get the struct that resides
under a Ruby object, use

{% highlight c %}
StructType * some_struct;
Data_Get_Struct(ruby_object, StructType, some_struct);
{% endhighlight %}

That will change the ` some_struct ` pointer to point
to your wrapped struct.


## Declaring Functions ##

The last part of the puzzle is function declaration.

{% highlight c %}
rb_define_singleton_method(class_Cranberry, "new",   class_method_new, -1);
          rb_define_method(class_Cranberry, "juice", method_juice,      1);
{% endhighlight %}

This tells Ruby to call ` class_method_new ` whenever
` Cranberry.new ` is requested, and ` method_juice `
whenever ` some_cranberry.juice ` is called.

The ` -1 ` and ` 1 ` are the arities that Ruby uses
internally to decide if there are enough arguments
and what arguments to pass to your function.

**NOTE:** These arities work different than the arities
you get from ` Method#arity `!

A positive number means, your function will take
just that many arguments, none less, none more.

<del>A negative number ` -n ` means, your function needs
*at least* ` n ` arguments, but can take more.
This is used for both, the splash arguments
(` def foo(*args) `), as well as optional arguments
(` def foo(x = 12) `).</del>

` -1 ` means the function takes a variable number of
arguments, passed as a C array.

` -2 ` means the function takes a variable number of
arguments, passed as a Ruby array.

In the next chapter I'll explain how that works in
detail.
So go and figure this out for your code, while I write
that chapter.


[Continue with Part 6!][part6]


[part1]:        ../../18/ruby-c-extension                           "Part 1 of this series"
[part6]:        ../../29/ruby-c-extension-6                         "Part 6 of this series"
[pickaxe]:      http://www.rubycentral.com/pickaxe/ext_ruby.html    "The Pickaxe on how to program Ruby in C"

