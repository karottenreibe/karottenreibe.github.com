---
layout: post
title: Bookmarks in uzbl
summary: |-
    How to store, set and remove your
    bookmarks in uzbl.
---

Now it's time to look at how uzbl can handle
bookmarks. Together with a good history, and
an omnicompletion they make your browsing rather
comfy.

[I wrote a little script][toggle] to handle the
storage of bookmarks. It keeps them in a plain
text file with each entry on a line and columns
separated by tabs. That keeps the whole thing
human-readable.

The script is best invoked via a keybinding:

    @cbind A    spawn @scripts_dir/toggle_bookmark.sh

Whenever you hit `A` from now on, a bookmark will
be added to the page if it doesn't already have one,
or removed if an entry already exists.

To distinguish between the two, you can use
[another script by moi][bmarked]. It will
set a variable (`@bookmarked`) in your uzbl
instance, which you can use in your status bar
or in the title format string to indicate wheter
the current page is bookmarked. The following
line ensures that it's called after every
page load:

    @on_event   LOAD_FINISH    spawn @scripts_dir/bookmarked.sh

Now add the following to your config:

    set bookmarked =
    set bookmark_section  = <span foreground="#606060">\@[\@bookmarked]\@</span>

And modify your `status_format` definition to include

    @bookmark_section

and your `title_format_long` and/or `title_format_short` to include

    \@bookmarked

and you're set!

[toggle]: http://github.com/karottenreibe/uzbl-scripts/blob/master/toggle_bookmark.sh "The toggle bookmark script"
[bmarked]: http://github.com/karottenreibe/uzbl-scripts/blob/master/bookmarked.sh "The bookmarked script"


