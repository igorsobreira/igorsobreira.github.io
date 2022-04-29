---
layout: post
title: Python 3.1.1. error on startup
---
After installing <a href="http://python.org/ftp/python/3.1.1/python-3.1.1.dmg">Python 3.1.1 for Mac OS</a> on my Leopard I got an error trying to start python3 from Terminal:

    $ python3
    Fatal Python error: Py_Initialize: can't initialize sys standard streams
    LookupError: unknown encoding: 
    Abort trap

There is a <a href="http://bugs.python.org/issue6393">"fixed" issue</a> in the bug tracker but the problem persists in my installation.
A quick workaround is to set LC_CTYPE properly. Check how it is now with the locale command (mine was UTF-8)

    $ export LC_CTYPE=en_US.UTF-8

Add this to your `~/.profile`.