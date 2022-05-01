---
layout: post
title: Unnecessary classes
---

Today I opened a python module that made me feel sad. It has two classes: one of them has 4 methods, all of them static, and no attributes; the other has only one method: `__init__`, and 5 attributes.

Why people still write classes like these?

## Use functions

...instead of classes with just static methods. If you have this class just to group the functions in a common namespace then create a new module (.py file), this is how python organize namespaces, and it's good, use it!

Here is the first class I saw today

{% highlight python %}
class Buttonate(object):

    @staticmethod
    def find_files(quiet=False):
        # ...

    @staticmethod
    def find_links(files):
        # ...

    @staticmethod
    def buttonate(buttons, overwrite=False, quiet=False):
        # ...

    @staticmethod
    def link_parser(file):
        # ...
{% endhighlight %}

and here is how I would rewrite it:

{% highlight python %}
def buttonate_find_files(quiet=False):
    # ...

def buttonate_find_links(files):
    # ...

def buttonate_buttonate(buttons, overwrite=False, quiet=False):
    # ...

def buttonate_link_parser(file):
    # ...
{% endhighlight %}

I usually just start creating the functions I need, and if I get to this point where I have multiple functions doing related work I just create a module and move them there:

{% highlight python %}
# new file: buttonate.py

def find_files(quiet=False):
    # ...

def find_links(files):
    # ...

def buttonate(buttons, overwrite=False, quiet=False):
    # ...

def link_parser(file):
    # ...
{% endhighlight %}


## Use builtin data structures

...instead of _attributes-only-classes_. Here is the other class I saw today:

{% highlight python %}
class ButtonLink(object):
    def __init__(self, matchobject, l):
    self.__dict__ = matchobject.groupdict()
    self.name = matchobject.group(0)
    self.size = int(self.size)
    self.colors = self.colors[1:].split(".")
    self.line = l
{% endhighlight %}

This is a class being used similar to a struct in C. We could use a dictionary here, and a factory function doing the work `__init__` is doing in this example:

{% highlight python %}
def create_button_link(matchobject, line):
    button_link = matchobject.groupdict()
    button_link.update({
        'name': matchobject.group(0),
        'size': int(button_link['size']),
        'colors': button_link['colors'][1:].split("."),
        'line': line
    })
    return button_link
{% endhighlight %}

Dictionaries are fast, [well](http://hg.python.org/cpython/file/tip/Objects/dictnotes.txt) [designed](http://hg.python.org/cpython/file/tip/Objects/dictobject.c) and are [always being improved](http://mail.python.org/pipermail/python-dev/2012-December/123028.html) by smart people.

Another interesting builtin data structure is [namedtuple](http://docs.python.org/2/library/collections.html#collections.namedtuple). And it has a clever [implementation](http://hg.python.org/cpython/file/baa7b5555656/Lib/collections/__init__.py#l233), you should check it out :)

One rule I follow when using dictionaries like the example above is to always modify them with specialized functions. You'll end up with well defined structures and modules that know how to build and manage these structures inside your application.

What I'm suggesting here is actually the opposite of OO, instead of writing a class with state and methods, keep the state on dictionaries (or tuples, lists, sets) and write functions to manipulate the state. I've been using this approach much more than classes lately.

## References

[Stop writing classes](https://www.youtube.com/watch?v=o9pEzgHorH0) is a great talk by Jack Diederich at python 2012, showing examples where classes are overused.
