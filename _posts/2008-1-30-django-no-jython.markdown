---
layout: post
title: Django no Jython
---
Django irá rodar no <a href="http://wiki.python.org/jython/FrontPage">Jython 2.5</a>, que será sua próxima versão, compatível com a 2.5 atual do CPython.

Atualmente ainda precisam de alguns <i>hacks</i> pra funcionar, e ainda tem algumas funcionalidades <i>quebradas</i>, como por exemplo o servidor de desenvolvimento tem que ser inicializado com `--noreload`.

Veja mais detalhes:
<a href="http://wiki.python.org/jython/DjangoOnJython"> DjangoOnJython </a>
<a href="http://www.infoq.com/news/2008/01/django_on_jython"> Python Web Framework on the JVM </a>