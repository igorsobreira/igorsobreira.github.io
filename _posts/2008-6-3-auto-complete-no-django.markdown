---
layout: post
title: Auto-complete no Django
---

Existe um script no diretório <a href="http://code.djangoproject.com/browser/django/trunk/extras">extras</a> do Django que oferece auto-complete nos scripts `django-admin.py` e no `manage.py`, é o <a href="http://code.djangoproject.com/browser/django/trunk/extras/django_bash_completion">django_bash_completion</a>.
Para usar basta adicionar a seguinte linha no seu arquivo `~/.bashrc`

    . /home/igor/django-trunk/extras/django_bash_completion

substituindo pelo seu diretório do django. Começará a funcionar quando você se logar novamente.

Eu utilizo a versão do trunk, não sei se esse escript vem no tarball da versão 0.96, provavelmente sim.
