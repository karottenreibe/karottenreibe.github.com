---
layout: post
title: Pimping awesome
summary: |-
    How i made my awesome a bit more awesome ;-)
---

[awesome][] is just that: awesome.

And a window manager also. But that only makes it to the second place.


I really like it as a window manager, mostly because it's 100% scriptable
so I can mess around with it a lot. ;-)

As I have been doing today. Today I enriched it with a fancy drop-down
terminal. You know -- as in those ego-shooters everyone's talking about.

The major coding behind this isn't mine, I just used [scratchpad][], a
very nice [Lua][] module that enables you to use any program for the drop-down.

But here's what I'd really like to share with you:

Scratchpad is fine, but it had some minor drawbacks for me, which, of course,
I had to fix immediately:

1.  Since I have a dual monitor setup, awesome has two screens to work with.
    The problem is now, that scratchpad will spawn a different termial for
    each screen -- suboptimal for me.
2.  If you get it to spawn only one terminal, it will not resize it when you
    call it on the other screen, which looks pretty nasty since my first screen
    isn't even half the size of my second one.

So I tweaked the sources and here's a little patch, if anyone would like to
have the same behaviour:

{% highlight diff %}
64,66c64,66
<     if not dropdown[prog][screen] then
<         spawnw = function (c)
<             dropdown[prog][screen] = c
---
>     -- Client geometry and placement
>     local place_client = function (c)
>         local screengeom = capi.screen[screen].workarea
68,69c68,69
<             -- Scratchdrop clients are floaters
<             awful.client.floating.set(c, true)
---
>         if width  <= 1 then width  = screengeom.width  * width  end
>         if height <= 1 then height = screengeom.height * height end
71,72c71,73
<             -- Client geometry and placement
<             local screengeom = capi.screen[screen].workarea
---
>         if     horiz == "left"  then x = screengeom.x
>         elseif horiz == "right" then x = screengeom.width - width
>         else   x =  screengeom.x+(screengeom.width-width)/2 end
74,75c75,77
<             if width  <= 1 then width  = screengeom.width  * width  end
<             if height <= 1 then height = screengeom.height * height end
---
>         if     vert == "bottom" then y = screengeom.height + screengeom.y - height
>         elseif vert == "center" then y = screengeom.y+(screengeom.height-height)/2
>         else   y =  screengeom.y - screengeom.y end
77,83c79,87
<             if     horiz == "left"  then x = screengeom.x
<             elseif horiz == "right" then x = screengeom.width - width
<             else   x =  screengeom.x+(screengeom.width-width)/2 end
< 
<             if     vert == "bottom" then y = screengeom.height + screengeom.y - height
<             elseif vert == "center" then y = screengeom.y+(screengeom.height-height)/2
<             else   y =  screengeom.y - screengeom.y end
---
>         c:geometry({ x = x, y = y, width = width, height = height })
>     end
> 
>     if not dropdown[prog][1] then
>         spawnw = function (c)
>             dropdown[prog][1] = c
> 
>             -- Scratchdrop clients are floaters
>             awful.client.floating.set(c, true)
86c90
<             c:geometry({ x = x, y = y, width = width, height = height })
---
>             place_client(c)
103c107
<         c = dropdown[prog][screen]
---
>         c = dropdown[prog][1]
112,114c116,117
<             -- Make sure it is centered
<             if vert  == "center" then awful.placement.center_vertical(c)   end
<             if horiz == "center" then awful.placement.center_horizontal(c) end
---
>             place_client(c)
> 
{% endhighlight %}

This is a diff for the ` drop.lua ` file of the scratchpad package. It's based off
[this git revision][revision].


[lua]: http://www.lua.org/ "Lua, the progamming language"
[awesome]: http://awesome.naquadah.org/ "His awesomeness"
[scratchpad]: http://awesome.naquadah.org/wiki/Scratchpad_manager "Scratchpad"
[revision]: http://git.sysphere.org/awesome-configs/plain/scratch/drop.lua?id=0c2cce8f14b0df3c755c429faf81ff32750ee160 "drop.lua"

