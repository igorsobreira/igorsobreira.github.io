---
layout: post
title: Generating test functions dynamically in Python
---

Some tests I write get tedious and repetitive, even with custom asserts to make it easier. For instance, take this test from a Django project I'm working on:

{% highlight python %}
import myapp.views

def test_my_view_requires_login():
    assert_login_required(myapp.views.my_view)
{% endhighlight %}

I have a `@login_required` decorator and a function `assert_login_required` that checks if a view has been decorated with it. I know the test is quite small but I decided to do some metaprogramming and simplify it even further:

{% highlight python %}
import myapp.views

ensure_login_required(myapp.views.my_view)
{% endhighlight %}

Here is the code for `ensure_login_required`:

{% highlight python %}
import sys

def ensure_login_required(view):
    """
    Generate a test function checking that 'view' is using @login_required
    """
    def test_func():
        assert_login_required(view)

    # get global namespace from where this function is being called, if I use
    # globals() here I'll actually get the global namespace of this module
    namespace = sys._getframe(1).f_globals
    namespace['test_%s_requires_login' % view.__name__] = test_func
{% endhighlight %}