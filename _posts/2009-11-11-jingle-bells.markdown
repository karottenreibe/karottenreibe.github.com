---
title: Jingle Bells, Jingle Bells...
summary:
    This time it's all about how to disable
    that annoying bell sound you sometimes
    get (and this time for sure)!
layout: post
---

# Christmas Carols #

No, I'm not going to start singing now...
Don't worry.

Actually, the topic has as much in common
with Christmas as Linus Torvalds with
the creation of Windows 7.

The bells I'm talking about aren't nice
and festivous and remind you of childhood
memories, warm stoves and a tree hung with
shiny decor.

The bells I'm talking about remind you of
your neighbour's annoying singing habit or
your sister's first lessons on the violin.

They suck!

Big time.

(And unlike your sister, they won't get
better over time...)

I'm talking about...


# ... the Linux PC speaker beep #

A lot of Linux users know the problem:

You hit backspace in the console once too
often -- it beeps.

You search something in Firefox and it doesn't
get any hits -- it beeps.

You auto-complete in your bash -- it beeps.


# Turning off, and off, and off... #

But as annoying the problem is, as hard it
can be to fix it.

First of all, there's a distinction between
console beep and X beep, so you will have
to turn off both.


# Turning off console beep #

In your ` ~/.inputrc `, add the line

    set bell-style none

and just to be sure, also add it to
` /etc/inputrc ` if that exists on your
system.

Also ensure there are no other ` set bell-style `
options.


# Turning off X beep #

In your ` ~/.xinitrc `, add the line

    xset -b

and you should be set.


# The loudspeaker beep #

There is one more variant of the really
annoying kind: The loudspeaker beep.

Normally, when a beep is produced, it
will be created by the interal speaker
of your PC, so you can hear it, even
when no loudspeakers are attached.

But in some rare cases, the sound can
be created by the loudspeakers of your
PC, but ignoring any of your volume settings.

Happened to me -- almost drove me nuts.

The problem is, if you overdo it.

If you have the above settings enabled
*and* remove the ` pcspkr ` module
from your kernel (as some sites recommend
you do), it *might* happen that your
loudspeaker starts to beep.

In that case, you have at some point
probably executed one of the following
commands:

    sudo modprobe -r pcspkr
    sudo rmmod pcspkr

To remedy the situation, just reinsert
the module:

    sudo modprobe pcspkr

(If you have even blacklisted it, undo
that.)


That should help remove *all* annoying
beep sounds. Hopefully...


