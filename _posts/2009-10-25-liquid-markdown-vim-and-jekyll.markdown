---
layout: post
summary:
    How to make Vim behave correctly with Liquid
    syntax highlighting tags in Markdown files
    when using Jekyll.
title: Liquid, Markdown, Vim and Jekyll
tag: '{%'
tag2: '{{'
---

# The Problem #

Since I started this blog, I have always
had the problem, that [Jekyll][] uses
[Liquid][] as a templating engine.

First I had to write Rakefiles that would
automatically compile my [HAML][] files into
HTML intermixed with Luquid, since I wanted to
avoid having to write that dreaded HTML (is
there actually anything worse? Besides XML
I mean...). I'm gonna write on how I did that
some time soon.

But then there was another problem:

Vim is of course not naturally guarded against
Liquid within [Markdown][] files, which I use
to compose the entries of this blog. Nor against
a YAML front matter.

So the syntax highlighting would get messed
up frequently when I wanted to post code, which I
would stash into

    {{ page.tag }} highlight ruby %}
    ...
    {{ page.tag }} endhighlight %}

tags to get the syntax highlighting of
Jekyll.

(**NOTE:** Another nice problem I ran into is trying
to get Liquid to output the liquid tags
you see above. It's parser is very limited
so it kept crashing whenever I put a ` } `
inside the tag. I ended up putting
` tag: {{ page.tag}} ` into the front matter and
replacing all occurrences of ` {{ page.tag}} ` with
` {{ page.tag2 }} page.tag }} `...)


# The Solution #

So today I told myself: That's enough!
And here's the result.

It actually turned out to be quite an
easy fix, mostly because of Vim's
ingenious syntax highlighting system
which is really easy to get used to
(if you know your Vim regexps).

I just modified my ` ~/.vim/syntax/mkd.vim `
and added the following lines after all
the ` syn region ` commands and before
any ` HtmlHiLink ` commands:

{% highlight vim %}
syn region lqdHighlight     start=/^{{ page.tag }}\s*highlight\(\s\+\w\+\)\{0,1}\s*%}$/ end=/{{ page.tag }}\s*endhighlight\s*%}/ contains=@Spell
syn region jkyFrontMatter   start=/\%^---$/                                 end=/^---$/                  contains=@Spell
HtmlHiLink lqdHighlight     String
HtmlHiLink jkyFrontMatter   String
{% endhighlight %}

That takes care of all the highlighting
tags and the YAML front matter.

(**Note:** the above listing was done
the same way as the previous one. It
actually took me a good half hour to
figure out how to do this... My first
approach was to just put it all into
the frontmatter, but
[a current Jekyll bug][jkybug] prevents
you from putting ` --- ` into the
frontmatter...)


[jekyll]:       http://github.com/mojombo/jekyll    "Jekyll static webpage generator"
[liquid]:      http://www.liquidmarkup.org/    "Liquid templating language"
[markdown]:     http://daringfireball.net/projects/markdown/    "Markdown text to HTML converter"
[haml]:         http://haml-lang.com/   "Awesome HAML templating language"
[jkybug]:       http://github.com/mojombo/jekyll/issues/#issue/93   "A Jekyll bug within frontmatter processing"

