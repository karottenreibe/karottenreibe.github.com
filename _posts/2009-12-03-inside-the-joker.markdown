---
layout: post
summary:
    I'm really fond of these state machines...
    I love state machines. Staty, staty, state
    machines.
title: 'Inside the Joker'
---

[Joker][] is a Wildcard matching library
for Ruby (a.k.a. [glob patterns][glob]).


# History Lesson #

It was born out of a Ruby mailing list posting,
which asked if there was a library for glob patterns
in Ruby -- which at the time there wasn't.

So I decided to write one. Couldn't be too hard now,
could it?


# First Attempt: Regexp Madness #

The first attempt was of course a lazy and
craziy one: Transforming the glob input string
into a regular expression and letting Ruby do the
rest.

Here's the "compiler":

{% highlight ruby %}
def compile
    ptr = 0
    compiled = '^'
    while ptr < @source.length
        snip = @source[ptr..ptr]
        case snip
        when '\\'
            lookahead = @source[ptr+1..ptr+1]
            case snip
            when '\\\\', '\\?', '\\*'
                compiled << snip << lookahead
            else
                compiled << Regexp.quote(lookahead)
            end
            ptr += 1
        when '?' then compiled << '.'
        when '*' then compiled << '.*'
        else          compiled << Regexp.quote(snip)
        end
        ptr += 1
    end
    compiled + '$'
end
{% endhighlight %}

Ugly? Sure. But works.


# The Crazier Path: C Extension #

Then one day an even crazier idea popped into my
head: why not make it perform super fast and
implement it in C? After all: C extensions rock
and I wanted to do one sometime anyways.

[The odyssey that ensued can be found on this blog][odyssey].


## State Machines! ##

So, to make my C code super awesome (!), I decided
(after some failed experiments with C string comparison
functions...) to do it with state machines.

Because state machines rock. Seriously.

I used two distinct state machines:

*   the compiler
*   the matcher

with the former transforming the input string
into a sequence of bytes (chars in C) and
the latter matching that byte sequence against
a string.


### The Compiler ###

[![The compiler state machine as I planned it][compiler]][compiler]

That's nice, isn't it?

It's not the final version, there have been
minor changes, but you get the idea.

The big bulbs are the states, the arrows are
the transitions, which are annotated with
the input (`EOS` means end of string) that
triggers the transition and
a (blue) number to identify the transition.

The ` /die ` and ` /warn ` annotations mean
that processing of the string is aborted
(in the former case) or a warning is issued
(in the latter case).

Different actions are taken whenever a
transition is triggered. This is done with
one BIG switch-case statement. The actions
range from *do nothing* to *add something
to the output byte string*.

Internally, the relationship between states,
input and transitions is represented by a
two-dimensional array. That corresponds to
a function ` state x input --> transition`.


### The Matcher ###

[![The matcher state machine as I planned it][matcher]][matcher]

This is a little more complicatied than
the compiler, but the basic principles are
the same.

Notice the rhombic field? That's a little
tricky. Here, a decision is made inside
transition 7, which enables the state
machine to [backtrack][]. It corresponds
to the ` push() ` action in transition 0.
Every push saves the state machine's
state and two pointers onto a stack and every
` pull() ` pops the last pushed state from
the stack. That way, the [kleene stars][kleene]
(` * `) are matched.

Also notice the dotted lines.
That's where the next picture comes in.


### The Monster ###

[![The monster state machine as I planned it][monster]][monster]

Whoa, what's that? Magic, that is...

This is how the matcher is used. Because one
matcher is not enough. In order to work
correctly, there have to be two state machines
matching at the same time: one from the left
and one from the right of the input.

They share the same match data, but may be
in different states. Also they do not run
in parallel, they take turns. Everytime
one calls ` push() `, the other may start from
the ` Base ` state. Everytime one calls
` pull() `, the other takes over where the
last ` push() ` left off.

That's what the dotted lines meant in the
second picture.

The two sort of close in on the middle
of the string that is matched and either
they meet in the middle (` success() `)
or one of them fails (` failure() `) and
the matching is aborted.

Nice... ;-)

I hope you liked the insight. I just love
that design :-)


[joker]:        http://karottenreibe.github.com/joker                           "Joker -- a wildcard matching library"
[glob]:         http://en.wikipedia.org/wiki/Glob_(programming)                 "Glob patterns a.k.a wildcards"
[odyssey]:      http://karottenreibe.github.com/2009/10/18/ruby-c-extension/    "My C extension adventures"
[compiler]:     /static/images/joker1.jpg                                       "Compile! I command thee!"
[matcher]:      /static/images/joker2.jpg                                       "Match! I command thee!"
[monster]:      /static/images/joker3.jpg                                       "Live! I command thee!"
[backtrack]:    http://en.wikipedia.org/wiki/Backtracking                       "What is backtracking?"
[kleene]:       http://www.websters-online-dictionary.org/Kl/Kleene+star.html   "What is a Kleene star?"

