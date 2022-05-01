---
layout: post
title: Replacing render_to_response with direct_to_template in Django
---

> **Update**: September 3, 2012
>
> [A `render()`](https://docs.djangoproject.com/en/1.4/topics/http/shortcuts/#render) [was introduced on Django 1.3](https://docs.djangoproject.com/en/1.4/releases/1.3/#everything-else) to use `RequestContext` by default

You certainly have already used `render_to_response` to render your templates, it's a very convenient shortcut:

{% highlight python %}
from django.shortcuts import render_to_response

def myview(request):
    ...
    return render_to_response('template.html', {'foo': ['one', 'two']})
{% endhighlight %}

At least until you need to use <a href="http://docs.djangoproject.com/en/1.2/ref/templates/api/#subclassing-context-requestcontext">context processors</a>, then you start writing code like this

{% highlight python %}
from django.shortcuts import render_to_response
from django.template import RequestContext

def myview(request):
    ...
    return render_to_response('template.html',
            {'foo': ['one', 'two']},
            context_instance=RequestContext(request))
{% endhighlight %}

this `context_instance` argument is the boilerplate code you will always need to make context processors work. I think it's too much typing, and I'm lazy, so I prefer to use the `direct_to_template` generic view:

{% highlight python %}
from django.views.generic.simple import direct_to_template

def myview(request):
    ...
    return direct_to_template(request, 'template.html',
            {'foo': ['one', 'two']})
{% endhighlight %}

You don't need the `context_instance` argument anymore, and you save one import.

But! There is one _simple_ detail when passing extra context to this view, if a value in your dict is a callable, it will call and pass the result to template. It can be useful, but is something to keep in mind, if you're trying to pass a callable to template.

Read the <a href="http://code.djangoproject.com/browser/django/trunk/django/views/generic/simple.py">source code</a> to understand how it works.
