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
