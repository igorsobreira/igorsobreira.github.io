---
layout: post
title: Customize settings.py locally in Django
---

The django configuration file is pure python code, this gives us a lot of flexibility to setup settings when the application starts. Actually you could even modify settings in runtime, but promise me you won't do this, ever!

Imagine you have an open-source django project, you have your code in github or something like that, but you probably don't want to publish your DATABASES configuration. Or maybe you can add all your server configuration under version control, it's private, great, but your local configuration is probably different too, you will need to set `DEBUG = True` at least.

There are a few ways to extend the settings.py file...

## Use the --settings option

The manage.py command has a `--settings` option that you can use to specify a different settings file, so you could have a `local_settings.py` file similar to:

{% highlight python %}
from settings import

DEBUG = True
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': 'db.sqlite',
        'USER': '',
        'PASSWORD': '',
        'HOST': '',
        'PORT': '',
    }
}
{% endhighlight %}

And locally you use:

    $ python manage.py runserver --settings=local_settings

This is the simplest way to extend the settings.py file and is probably enough for most situations, but let's take a look in other options.

## Importing from settings.py

This method is the opposite from above. In the end of your settings.py you add:

{% highlight python %}
try:
    from local_settings import
expect ImportError:
    pass
{% endhighlight %}

Now you `local_settings.py` file won't need to import anything from settings.py, just set your configuration variables. And you don't need to pass `--settings` anymore.

## Adding code dynamically to settings.py

This is similar to the method above but gives you more flexibility. Imagine you need a `local_settings.py` file similiar to this:

{% highlight python %}
DEBUG = True
INTERNAL_IPS = ('127.0.0.1',)
MIDDLWARE_CLASSES = MIDDLWARE_CLASSES + ('debug_toolbar.middleware.DebugToolbarMiddleware',)
INSTALLED_APPS = INSTALLED_APPS + ('debug_toolbar',)
{% endhighlight %}

How could you use `MIDDLWARE_CLASSES` or `INSTALLED_APPS` from settings.py if you didn't import those? Here is the answer:

{% highlight python %}
import os

PROJECT_ROOT = os.path.dirname(file)
try:
    execfile(os.path.join(PROJECT_ROOT, 'local_settings.py'), globals(), locals())
except IOError:
    pass
{% endhighlight %}

The trick here is the <a href="http://docs.python.org/library/functions.html#execfile">execfile</a> function, it reads the content of the file and _appends_ it to the file you calling from. In the end, it's like the contents of you `local_settings.py` file are inside settings.py.

## Host specific settings

Now you already have a way to customize your settings locally, just create a `local_settings.py` file, don't add it under version control, and add one of these code snippets in the end of your settings.py.

But what if you need specific settings per host? You have this project that runs on multiple servers, and you want specific settings for each one. You could create a `settings_<SERVER_HOSTNAME>.py` file, and import dynamically:

{% highlight python %}
import socket
import os

PROJECT_ROOT = os.path.dirname(file)
settings = 'settings_%s.py' % socket.gethostname()

try:
    execfile( os.path.join(PROJECT_ROOT, settings), globals(), locals())
except IOError:
    pass
{% endhighlight %}

To view your hostname just execute:

    $ hostname
    globo-mac

so, in my case I have a file called `settings_globo-mac.py`

## Conclusion

That's it! How I said in the beginning, settings.py is just python, this gives us a lot of power to customize our settings dynamically. If you have another idea let us know.

See you!
