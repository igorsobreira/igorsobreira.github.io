---
layout: post
title: Change object after saving all inlines in Django Admin
---

> **UPDATE Aug, 2011**: <a href="https://code.djangoproject.com/ticket/16115">This patch</a> added a new hook to `ModelAdmin` called `save_related()`. You don't need the *hack* described bellow anymore :).

***

Admin is an awesome Django builtin app to create nice CRUDs for your models, and offers a lot of customizations hooks. You can personalize the templates, perform custom filters, modify newly created objects and if that's not enough, you can always create your own view to do something it doesn't by default.

The <a href="http://docs.djangoproject.com/en/dev/ref/contrib/admin/">admin docs are great</a>, I'm not going to explain how it works. The intention here is to show a way to modify an object, after it's saved, and other objects related to it using <a href="http://docs.djangoproject.com/en/dev/ref/contrib/admin/#inlinemodeladmin-objects">inlines</a> are saved too.

Once you've configured your admin interface with inlines, you end up with something similar to:

{% highlight python %}
from django.contrib import admin
from fooapp.models import Foo, Related

class RelatedInline(admin.TabularInline):
    model = Related

class FooAdmin(admin.ModelAdmin):
    inlines = [RelatedInline]

admin.site.register(Foo, FooAdmin)
{% endhighlight %}

this mean whens you're adding a `Foo`, since `Related` has a foreign key to it, django will display a few forms to add `Related`s in the same page.

Imagine you need to do something with the new `foo` instance that needs to now how many `related` objects it has. <a href="http://docs.djangoproject.com/en/dev/ref/contrib/admin/#modeladmin-methods">Admin already has methods you can override</a> to do something after `Foo` is saved, like `ModelAdmin.save_model()`. See how it works:

{% highlight python %}
class FooAdmin(admin.ModelAdmin):
    inlines = [RelatedInline]

    def save_model(self, request, obj, form, change):
        obj.save()
        # do something with obj.related_set.all()
        # OPS! it's empty!

admin.site.register(Foo, FooAdmin)
{% endhighlight %}

the problem here is that `save_model()` is called **before** the inlines are saved.

Let's find out how it works. Open django source code, specifically in <a href="http://code.djangoproject.com/browser/django/trunk/django/contrib/admin/options.py">django.contrib.admin.options.py</a> go to `add_view()`, it's the view called when you are creating an object. As you can see, when the request method is "POST" it goes through all validation, for the main form and all related formsets (your inlines). And if all of then are valid it calls `save_model()`, then `save_formset()` for each formset. The interesting piece is shown below:

{% highlight python %}
class ModelAdmin(BaseModelAdmin):

    # ...

    def add_view(self, request, form_url='', extra_context=None):

        # ... all validation here ...

        if all_valid(formsets) and form_validated:
            self.save_model(request, new_object, form, change=False)
            form.save_m2m()
            for formset in formsets:
                self.save_formset(request, form, formset, change=False)

            self.log_addition(request, new_object)
            return self.response_add(request, new_object)
{% endhighlight %}

Notice here that the last method it calls is `response_add()`, and it passes the created object, that's all we need! If you see the `change_view()` method (witch it the view called when you're editing an object) it calls a similar method: `response_change()`.

Now we can solve our problem doing something like this:

{% highlight python %}
class FooAdmin(admin.ModelAdmin):
    inlines = [RelatedInline]

    def response_add(self, request, new_object):
        obj = self.after_saving_model_and_related_inlines(new_object)
        return super(FooAdmin, self).response_add(request, obj)

    def response_change(self, request, obj):
        obj = self.after_saving_model_and_related_inlines(obj)
        return super(FooAdmin, self).response_change(request, obj)

    def after_saving_model_and_related_inlines(self, obj):
        print obj.related_set.all()
        # now we have what we need here... :)
        return obj
{% endhighlight %}

There are two things to keep in mind when using these methods:

- They are not documented. So probably it's not part of the API admin expects you to override. Thankfully django publishes excellent release notes including backwards incompatible changes. And I hope you have good test coverage to know if it will break when you update django :)
- Their intention is to handle the response of the view, as it docstring says: "Determines the HttpResponse for the add_view stage". So if you do something there not related to it, it works, wont make much sense if you look at the overall architecture.

Maybe django will add a more specific hook to solve this issue later, but I hope it helps you for now.
