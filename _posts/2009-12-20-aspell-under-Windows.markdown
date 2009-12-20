---
layout: post
title: Aspell under Windows
summary:
    In an effort to bring the stuff from my old
    "blog" back to liff, I ported some articles,
    including this one about how to make aspell
    0.60 work under Windows.
---

[Aspell][] is a "cross-platform" spellchecker.

I say "cross-platform", since the official Linux release is currently 0.60.something,
the official Windows version has been stuck at 0.50.something since 2002...

I recently needed to setup aspell under Windows centrally on a network share with a
central config since it was going to be used by multiple PCs in the network for the
very same task and I of course rather wanted to use
the new 0.60 instead of the old one. So I googled a bit and I found many posts of
people sharing the same fate as me, but I could only get three different answers:

1.  Get a patch for 0.60 that makes it compilable under Windows
    I only found one of those ominous patches and it was for VC++
    with which I have made some bad experiences, so I refrained
    from doing that... Might work, might not, I don't know.
    Unfortunately I didn't jot down the URL of the page where I
    found it...

2.  Use the 0.50 version.
    Well, that's an option, but there is one very, *VERY* major
    disadvantage with that thing: You can't have a config file.
    I.e. in theory you can, but I couldn't figure out where to
    put it so aspell finds it and the crooked Windows port is
    compiled without the ominous --enable-win32-relocatable flag
    that would allow you to change the path it searches for the
    config file in.
    Which left me only with the third alternative.

3.  Use [cygwin][].
    That worked out pretty neat. First I thought I'd compile the
    0.60 version under cygwin using mingw, but then I realised
    that there is already a precompiled package available!
    The only disadvantage here is the final size. Aspell itself
    is pretty much nothing, but cygwin adds a good 20MB to it...

So what I did was this:
First I installed the package plus the two dictionaries I needed
(en and de, both available as separate packages as well).

Then I did some file copying.
I made the folder where aspell was to reside, let's call that _x:\aspell_
and let's furthermore assume that cygwin is installed to _c:\cygwin_.

Then, from _c:\cygwin\usr\bin_ I copied

    aspell.exe
    cygaspell-15.dll
    cygncurses-8.dll
    cygwin1.dll
    cygiconv-2.dll
    cygintl-8.dll
    word-list-compress.exe

to _x:\aspell\bin_.

After that, I copied the folder _c:\cygwin\usr\lib\aspell-60\_
to _x:\aspell\data_.

And that's about it!

Now all that remains to do is to adjust the config file,
I called it _x:\aspell\aspell.conf_:

    prefix           /cygdrive/x/aspell
    home-dir         /cygdrive/x/aspell/home
    data-dir         /cygdrive/x/aspell/data
    dict-dir         /cygdrive/x/aspell/data
    local-data-dir   /cygdrive/x/aspell/data

Those lines tell it where to search for the data, dictionaries and
user dictionaries.

Now you should be able to call aspell as

    x:\aspell\bin\aspell.exe -a --conf-dir = x:\aspell --conf=aspell.conf --lang=en

[aspell]: http://www.aspell.net
[cygwin]: http://www.cygwin.com

