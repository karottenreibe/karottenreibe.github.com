---
layout: post
title: Adding commands to uzbl
summary: |-
    Today I present my command plugin, which enables
    you to define your own vim-like commands.
---

[As I was saying earlier][uzbl-post]: uzbl rocks!

So, here's a little follow-up which tells you how to
not only get vim-keybindings in uzbl (which you get
for free and by default), but also vim-commands
that even integrate with autocompletion and wrap
transparently around all uzbl builtins.

The trick is [this little plugin I wrote][plug].

It gives you two new requests:

    request DEF_COMMAND name implementation
    request EXEC_COMMAND name args

The first defines a new command with the given name
and an implementation, the second executes such a
custom command **and** any uzbl builtin.

I like to shorten the above with the following
definitions:

    set def = request DEF_COMMAND
    set exec = requests EXEC_COMMAND

Then you can redefine the `:_` prompt as follows:

    @cbind :_ @exec %s

Now on to some examples.

I like to type `:q` to close my browser window,
so I defined

    @def q    exit

Even more, since I'm not using uzbl-tabbed, I
like to type `:qall` to kill all my open uzbl
windows

    @def qall    sh 'killall uzbl-core'

Or how about a command to reload your config?

    @def config-reload    sh "sed '/^# === Post-load misc commands/,$d' $1 | grep '^set ' > $4"

Now go into your uzbl and test it. Nice, huh ;-)


[uzbl-post]: /2010/06/16/best-----browser-----ever-/ "Why uzbl rules"
[plug]: http://github.com/karottenreibe/uzbl/blob/commands/examples/data/plugins/commands.py "The command plugin"

