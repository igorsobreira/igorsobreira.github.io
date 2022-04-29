---
layout: post
title: Improving performance of Django test suite
---

I'm working on a small django application these days which offers templates to override <a ref="https://github.com/sehmaschine/django-filebrowser">django-filebrowser</a>'s templates to remove the Grappelli dependency.

It's a small app, consisting 99% of templates. There are only 19 tests which take 35 seconds to execute! All of them performs at least one request using django test client, no selenium, no real HTTP requests, and still 35 seconds!

![Tests speed very slow](/assets/uploads/tests-speed-very-slow.png)

After a run with <a href="http://docs.python.org/library/profile.html">cProfile</a> I've noticed many calls to hash functions, specifically <code><a href="https://github.com/django/django/blob/master/django/utils/crypto.py#L135">django.utils.crypto.pbkdf2()</a></code> and it's helper <code>_fast_hmac</code>. Then I came up with this very complex patch to my settings:

	+    PASSWORD_HASHERS = (
	+        'django.contrib.auth.hashers.UnsaltedMD5PasswordHasher',	
	+    ),

Now the tests execute on 6 seconds!

![Tests speed improved](/assets/uploads/tests-speed-improved.png)

You probably want a safer hash function for your user passwords in production, but there is no problem to use a simpler one for tests. This extensible way to deal with password hashers was introduced in Django 1.4, you can <a href="https://docs.djangoproject.com/en/1.4/topics/auth/#how-django-stores-passwords">read more about it on the docs.</a>