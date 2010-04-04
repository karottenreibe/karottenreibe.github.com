---
layout: post
title: Creating a backup warning system
summary: |-
    My efforts to get myself to backup more regularly.
---

Backing up your data is important. I know that. Nonetheless I tend to forget
to make backups pretty easily. It just doesn't come naturally to me.

So I thought to myself: "You should have a warning system, that informs you
when a new backup is due, in a way that you can't miss.". And that's what I
did.

Now, since I don't like audible alerts (and since my speakers are off by default),
it had to be a visual alert. And where would one put such an alert?

Popup windows are too easily clicked away and generally very annoying. Augmenting
my bash prompt would destroy my workflow pretty easily and distract me too much.
So it had to be a place I look at regularly that has enough space to display a
big warning but where the additional image doesn't disturb me.

On my system, there is only one such place: by desktop background.

So I wrote myself a little script that inserts this little image into the top
left corner of my background image(s) when a backup is due:

![My backup bubble][backmeup]

and another one that removes it again.

To combine the two images, I use [ImageMagick][]'s ` combine ` tool:

    combine back_me_up.png background.png warning_background.png

Then I just set that as the new background (I use [feh][] and [nitrogen][] for that task).

In combination with a script that checks if a backup is due and a [cron][] job,
my backup warning system is complete.


[backmeup]: /static/images/back_me_up.png "My backup bubble"
[imagemagick]: http://www.imagemagick.org/ "ImageMagick, a command line image manipulation program"
[feh]: http://linuxbrit.co.uk/software/feh/ "A lightweight image viewer with some extras"
[nitrogen]: http://projects.l3ib.org/nitrogen/ "Nitrogen, a background browser and setter for X"
[cron]: http://en.wikipedia.org/wiki/Cron "You know cron, it's tron's little sister!"

