---
layout: post
title: Vagrant plugin to take screenshots
---

I've been using [Vagrant](http://vagrantup.com) a lot at work. These days we were facing some problems when our VMs were booting and a friend, <a href="http://twitter.com/jbochi" title="Juarez Bochi">jbochi</a>, came up with an idea to take a screenshot from a running VM.

He found this command on `VBoxManage`:

    $ VBoxManage controlvm [vm-uuid] screenshotpng [output-filename]

And it helped a lot! That's when we had the idea to wrap this command in a script to keep using. Initially I've created a small python script, but then reading about <a href="http://vagrantup.com/docs/extending/index.html">vagrant plugins</a> (<a href="http://twitter.com/hltbra" title="Hugo Lopes Tavares">hltbra</a>'s suggestion) I've decided to create one.

The <a href="http://github.com/igorsobreira/vagrant-screenshot/">vagrant-screenshot</a> plugin is very simple. You just need to install <a href="https://rubygems.org/gems/vagrant-screenshot">the gem</a> and use:

    $ gem install vagrant-screenshot

Here is an usage example:

    $ vagrant screenshot -o
    [vagrant] Taking screenshot for default
    [vagrant] Screenshot saved on screenshot-default.png

By default it takes screenshots for all active VMs. The <code>-o (--open)</code> option opens the images when done (only works on OS X for now)

See the help for more details

    $ vagrant screenshot --help

PS.: The problem I've mentioned we were facing ended up in a <a href="https://github.com/mitchellh/vagrant/pull/771">pull request to vagrant</a>, but unfortunately it wasn't accepted :o)