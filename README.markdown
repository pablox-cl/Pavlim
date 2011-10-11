Pavlim
======

This is a basic set of plugins and stuff, it's based mainly on [gavim2](https://github.com/gaveen/gavim2/), [Janus](https://github.com/carlhuda/janus) and some lost vimrc by [Jeffrey Way](http://net.tutsplus.com/articles/general/top-10-pitfalls-when-switching-to-vim/ "Top 10 pitfalls when switching to vim").

Right now is it under heavy development, so don't expect something functional.

Install instructions
====================

    git clone git://github.com/PaBLoX-CL/Pavlim.git
    rake

The default rake task (`:init`) installs pathogen's last version and updates
the vim plugins.

Update pavlim:

    rake update_pavlim

or...

    rake update_all

...if you want to update pavlim and every other plugin.

Features
========

## Base customizations ##

## [Zencoding-vim](https://github.com/mattn/zencoding-vim) ##

Zen coding is a plugin editor that helps you write faster html (or any
other structured language) code, through a series of abbreviations that
can be expanded to functional HTML code.

**Customizations:**
* Leader key: <C-e>
* Expand key: <C-e>,

Notes
=====

### Default font ###

The default font included in this bundle is Inconsolata-g, a modified
version of the Inconsolata font, so if you're having issues like the
default font is ugly, this could be the problem. This font can be
downloaded for free from [Leonardo Maffi](http://www.fantascienza.net/leonardo/ar/inconsolatag/inconsolata-g_font.zip).

Issues?
=======

If you have any problem, think that something can work better or want to
give some feedback, please don't hesitate in contacting me through my
e-mail pablo (at) glatelier (dot) org, via github message or filing an
issue in the github tracker.

Copyright
=========

Copyright (c) 2011 Pablo Olmos de Aguilera Corradini. See LICENSE for
details.
