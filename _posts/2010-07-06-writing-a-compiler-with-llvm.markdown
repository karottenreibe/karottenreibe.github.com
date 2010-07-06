---
layout: post
title: Writing a compiler with LLVM
summary: |-
    My experiments with the LLVM and the compiler
    that came out of it.
---

I recently discovered that there is an [excellent tutorial][tut]
for the LLVM that implements a JIT compiler for a little
functional language called Kaleidoscope.

And since we just had the [LOOP language][loop] in our
theoretical computer science course at university, I decided
to write a little compiler for that very simple language.

And three days later, the [LOOP compiler][comp] was born.

If you're interested in how it works, better read the
Kaleidoscope tutorial. My sources are rather scarcely
documented.

One word of warning though: Their for loop is a bit broken,
it'll iterate one time more often than you request ;-)


[tut]: http://llvm.org/docs/tutorial/ "Comprehensive tutorial for LLVMs basic features"
[loop]: http://de.wikipedia.org/wiki/LOOP-Programm "Couldn't find an English reference"
[comp]: http://github.com/karottenreibe/loop "The LOOP compiler"

