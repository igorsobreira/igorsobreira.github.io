---
layout: post
title: Django readonly fields in Admin
---

Finally Django has implemented <a href="http://docs.djangoproject.com/en/dev/ref/contrib/admin/#django.contrib.admin.ModelAdmin.readonly_fields">readonly fields</a> in Admin interface. It's a new feature in 1.2 which is in alpha version at this moment, but will be released soon.

The feature is really simple and is <a href="http://docs.djangoproject.com/en/dev/ref/contrib/admin/#django.contrib.admin.ModelAdmin.readonly_fields">already documented</a> so I won't explain how it works. But there is one implementation detail not documented that gives much more power to this feature. If you check the admin sources, you'll find a method called get_readonly_fields() in django/contrib/admin/options.py, by default it just returns self.readonly_fields, which is the normal usage, but since you receive the request object as a parameter you can enable or not some fields depending on the logged in user.

Here is an example where a slug field can just be edited by superusers:

{% highlight python %}
class FooModelAdmin(admin.ModelAdmin):
    ...
    def get_readonly_fields(self, request, obj=None):
        if request.user.is_superuser:
            return ()
        return ('slug',)
{% endhighlight %}

There are <a href="http://djangoadvent.com/1.2/">lot's of interesting new features in Django 1.2</a>, I'm looking forward for it!