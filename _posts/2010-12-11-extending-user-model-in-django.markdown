---
layout: post
title: Extending the User model in Django
---

Django brings a built-in <a href="http://docs.djangoproject.com/en/1.2/topics/auth/">user authentication system</a>, it includes an <a href="http://docs.djangoproject.com/en/1.2/topics/auth/#users">User model</a> which has the most common attributes. But in most applications you may need to store additional attributes to users. Django <a href="http://docs.djangoproject.com/en/1.2/topics/auth/#storing-additional-information-about-users">has a way to do this</a> too.

## Extending using foreign key

Basically you create your `UserProfile` model with a `OneToOneField` to `User`:

    class UserProfile(models.Model):
        user = models.OneToOneField('auth.User')
        bio = models.TextField()
        # ...

and define in on settings.py

    AUTH_PROFILE_MODULE = 'accounts.UserProfile'     # app name (dot) model name

From now on your `User` objects will have a `get_profile()` method.

I personally can't see a reason to use this setting (and I hate "getters" methods), you just need to do this:

    class UserProfile(models.Model):
        user = models.OneToOneField('auth.User', related_name='profile')
        bio = models.TextField()
        # ...

See the `related_name='profile'` parameter, now you don't need the `get_profile()` method anymore, just use `user_instance.profile`.

But there is a small problem here, if the user instance don't have a profile related to it you will receive an `ObjectDoesNotExist` exception. This happens with `get_profile()` too. And it's not good to handle the exception every time you access the profile. The simplest way to solve this is connect to <a href="http://docs.djangoproject.com/en/1.2/ref/signals/#django.db.models.signals.post_save">`django.db.models.signals.post_save`</a> on the `User` model and create your `UserProfile` instance related to it

    from django.db.models import signals
    from accounts.models import UserProfile

    def create_user_profile(sender, instance, created, **kwargs):
        if created:
            UserProfile.objects.create(user=instance)

    signals.post_save.connect(create_user_profile, sender=User)

## Why subclassing User is a bad idea

There are a few reasons I prefer to create user profiles as another model instead of just subclassing the default User. If you think for a while, an user has a lot to do in your site, and there are at a few default steps:

- first she needs to register, confirm by email, and so on
- login and logout, change and reset password
- admins may need to manage groups and permissions, to restrict user actions, offer features to specific groups
- manage profile, with personal information

Django doesn't handle the first topic, there is a <a href="http://djangopackages.com/packages/p/django-registration/">great app to handle registration</a>.

The second and third topics can be done with `django.contrib.auth` app, this is exactly it's purpose.

And then you have the forth topic, which is profiles. As you can see, it can be done as a separate app. A user _has_ a profile. So makes sense to have a `profile` attribute in the User object.

If you split features in apps like this it's easier to reuse too, that's the idea of django apps after all! The <a href="http://djangopackages.com/packages/p/django-registration/">django-registration</a> is an example. And as you can imagine, there <a href="http://djangopackages.com/grids/g/profiles/">are apps to manage profiles</a> too.

## Editing User profile in admin

If you're using admin you may want to edit the UserProfile fields in the same page as the User fields, and it's possible using <a href="http://docs.djangoproject.com/en/1.2/ref/contrib/admin/#inlinemodeladmin-objects">admin inlines</a>. Here is how you admin configuration will look like:

    from django.contrib import admin
    from django.contrib.auth.admin import UserAdmin as DjangoUserAdmin
    from django.contrib.auth.models import User

    from accounts.models import UserProfile

    class UserProfileInline(admin.TabularInline):
        model = UserProfile

    class UserAdmin(DjangoUserAdmin):
        inlines = (UserProfileInline,)

    admin.site.unregister(User)
    admin.site.register(User, UserAdmin)

## Conclusion
As you can see, it quite easy to manage user profiles in django. Although there is a way to hook you profile model in settings.py, you can do it with a simple foreign key. And as usual, there are a few reusable apps around to handle the generic stuff.
