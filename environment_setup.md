Environment setup
=================

Update Raspbian
---------------

> $ sudo apt-get update
> $ sudo apt-get upgrade

OPTIONAL: Free up some space
(remove scratch, wolfram (+ mathematica), ruby1.9.1 & ri1.9.1 (+ sonicpi) )
Why? Installation on Pi may be slow and require a lot of disk space, as ruby 
may need to be compiled from source.

> $ sudo apt-get remove scratch wolfram-engine ruby1.9.1 ri1.9.1

Install RVM + rails + ruby
--------------------------

Note: as normal user, no need to be root

> gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
> $ \curl -L https://get.rvm.io | bash -s stable --rails

To use RVM in current shell:
> $ source ~/.rvm/scripts/rvm


Project specific packages and gems
----------------------------------

1. Execjs and nodejs

> $ gem install execjs
> $ sudo apt-get install nodejs

2. GSTreamer & gstreamer bindings

> $ gem install glib2
> $ gem install gstreamer

*THERE IS A BUG IN GSTREAMER GEM 2.2.0*
FIX:
https://github.com/ruby-gnome2/ruby-gnome2/commit/29dd9ccdf06b2fe7d9f5cf6ace886bb89adcebf2