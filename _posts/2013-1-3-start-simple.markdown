---
layout: post
title: Start simple
---

Last week I wrote a [post about unnecessary classes](http://www.igorsobreira.com/2012/12/31/unnecessary-classes.html), and that kept me thinking about how common people write classes or more complex designs upfront just because it would be easier to evolve and extend later.

One suggestion I gave was to use a dictionary instead of a class which had no methods but the constructor. This class was just holding state, data, so a dictionary is enough. Let's start simple...

I'll stick with this example because it's real code, even if it's purpose is not 100% clear:

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

this function returns a dictionary with many properties of a button, ok. But now I need to increase its size, I could write a function like:

{% highlight python %}
def increase_button_link_size(button_link, pixels):
    button_link['size'] += pixels
    return button_link
{% endhighlight %}

At some point you may want to change the design and make a `ButtonLink` class, maybe because you need a much more complex model and OO could help. Anyway, here is how the class could be implemented:

{% highlight python %}
class ButtonLink(object):
    def __init__(self, matchobject, line):
    self.__dict__ = matchobject.groupdict()
    self.name = matchobject.group(0)
    self.size = int(self.size)
    self.colors = self.colors[1:].split(".")
    self.line = line

    def increase(self, pixels):
        self.size += pixels
{% endhighlight %}

the problem now is that `button_link`s are being used as dictionaries all over the place, like `button_link['size']`. And even worse, this could be a public API and you may not have access to the clients using it. In this case we could simulate the dict api implementing `__getitem__`:

{% highlight python %}
import warnings

class ButtonLink(object):
    # ... same as above

    def __getitem__(self, item):
        warnings.warn("Dict-like access is deprecated, please use `.{0}`"
                    .format(item), DeprecationWarning)
        return getattr(self, item)
{% endhighlight %}

Now you can use `button_link.size` and `button_link['size']`. And I also added a deprecation warning to notify the users that they should use the object API from now on.
And you should also modify the functions above to create and manipulate the object instead of the dictionary, also raising warnings if you want.

You may want to implement other dictionary methods, like `keys`, `items`, `has_key`, `__contains__`, etc.

### Why not make a dict subclass?

The main reason I wouldn't subclass `dict` in this case is philosophical: `ButtonLink` should behave like a `dict` (temporarily), but it is not a dictionary. A good example of a `dict` subclass is [`OrderedDict`](http://hg.python.org/cpython/file/tip/Lib/collections.py), it is a dictionary with customized behavior.

Another aspect to keep in mind is when we write a subclass is that we inherit all the methods from the superclass, all the API, and it's now part of my class API. In my case I don't want to implement the `__setitem__` method, because the clients should not be using it, all the time you need to modify the `button_link` dict there is a specialized function to do so, and these functions I can easily rewrite to use the object API.

_"What about `isinstance()`?!"_. Yeah, you're going to loose it, since `button_link` is not a `dict` anymore `isinstance(button_link, dict)` is False. But I believe you should not be using it, type checking with `isinstance()` and even worse, `type()`, is not very common on languages like python. "If it walks like a duck and quacks like a duck, then it is a duck"! I know that sometimes `isinstance()` is handy, but I don't think it's appropriate here because of the philosophical argument I gave above.

### Conclusion

**Start simple, it's always easier to evolve to a more complex design than the other way around**.

Using Python [magic methods](http://www.rafekettler.com/magicmethods.html) your objects can easily look like a native data structure, so start using simple data structures and write your own if you need later. Another language feature that helps this incremental design evolution is [properties](http://docs.python.org/2/library/functions.html#property), a simple attribute can evolve to a complex getter/setter transparently.

Don't forget the Zen of Python:

> Simple is better than complex.
> Complex is better than complicated.
