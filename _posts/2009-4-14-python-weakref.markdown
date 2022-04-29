---
layout: post
title: Python weakref
---

Existe um módulo bem interessante na biblioteca padrão do Python que eu não conhecia até pouco tempo atrás, o <a href="http://docs.python.org/library/weakref.html">weakref</a>. Ele serve pra manter uma "referência fraca" para um objeto. Mas o que seria isso? 
Uma _weak reference_ não é suficiente para manter o objeto na memória, então se só existir esse tipo de referência para o objeto, o coletor de lixo vai destruí-lo.

Isso é interessante pra evitar um alto consumo de memória com objetos muito grandes que não deveriam mais estar vivos. Um problema que pode acontecer usando o padrão de projeto <a href="http://en.wikipedia.org/wiki/Observer_pattern">Observer</a> (<del>mal implementado</del>), por exemplo .

Um exemplo
{% highlight pycon %}
>>> class Foo(object):
...   def say_hello(self): print 'say hello'
... 
>>> a = Foo()
>>> a.say_hello()
say hello
>>> r = weakref.ref(a)
{% endhighlight %}

`r` é uma referência fraca para o objeto a

{% highlight pycon %}
>>> r() is a
True
>>> r().say_hello()
say hello
>>> del a
>>> from gc import collect
>>> collect()	# forçando a coleta de lixo
0
>>> print r()
None
{% endhighlight %}

Já existem classes úteis que usam weak references: WeakKeyDictionary e WeakValueDictionary. Vale a pena dar uma olhada na documentação:

<a href="http://docs.python.org/library/weakref.html">http://docs.python.org/library/weakref.html</a>
