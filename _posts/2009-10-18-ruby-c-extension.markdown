---
layout: post
title: Ruby C Extensions -- Part 1
---

# Cooking up a Ruby C Extension #

I've always wanted to try making a Ruby C Extension,
for once because I wanted to know what was going on
under Ruby's hood and then again because I wanted to
see if writing for Ruby in C is as easy as writing
in Ruby itself.

It, of course, is not.

But that's mainly because writing in C is a pain in
the \*#?!, not because the interfacing-with-Ruby part
is hard to do.

Anyways, after coming up with a pure Ruby gem for wildcard
matching ([Joker][]) I thought: Hey, that would make an excellent
C extension!

So I ventured out on a journey to conquer the Ruby C extension
world -- or at least leave a footprint on its ground.

This article and it's followers are my idea of a map of
my journey and the holes I fell in and stones I tripped
over, so you won't have to.

I hope it helps someone.


# First off: Getting the Right Tools #

One of the most important things when developing Ruby
C extensions is to get your toolset right. If you
start out with none or the wrong tools, you're sooner
or later going to get lost in the compiler jungle.

So you better plan ahead and have them installed.

Here's a list of what I recommend:

*   A C compiler (obviously). I used GCC on my linux
    box. That also let's you cross-compile for the
    poor Windows fellows that have never seen a
    compiler at work in their entire life. ;-)
*   [rake-compiler][]: The most important tool around.
    Takes care of all compilation for you (yes, all).
    Especially when you've never done a Ruby extension
    before, that's really helpful.
*   [rake-tester][]: A simple addition to rake-compiler
    written by myself
    that allows you to use C testing frameworks to test
    your pure C code. I find that quite helpful.
*   [valgrind][]: A must-have. This is the single most
    helpful tool when writing C or C++ code I've ever
    seen. It really helps you get rid of all the
    mean and nasty malloc/realloc/free memory bugs
    and trace down memory access violations and leaks.

Great! Now run off to your nearest package manager and
get them all! Meanwhile, I'll finish the next part of
my little narration...



[joker]:            http://karottenreibe.github.com/joker   "Joker -- A Ruby library for Wildcard matching"
[rake-compiler]:    http://github.com/luislavena/rake-compiler  "rake-comiler -- The compiler genie that will grant all your wishes"
[rake-tester]:      http://www.github.com/karottenreibe/rake-tester  "rake-tester -- Testing Ruby C Extensions with C frameworks"
[valgrind]:         http://valgrind.org/    "Valgrind -- Trace down your memory leaks!"

