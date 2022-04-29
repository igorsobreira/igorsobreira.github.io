---
layout: post
title: Properties no Python 2.6
---

Uma das features que eu mais gosto em Python são as <a href="http://docs.python.org/library/functions.html#property">properties</a>. Elas são possíveis graças aos <a href="http://docs.python.org/reference/datamodel.html#implementing-descriptors">descriptors</a>, mas isso é assunto pra outro post. E na versão 2.6, as properties ganharam 3 atributos: getter, setter e deleter. Veja mais <a href="http://docs.python.org/dev/whatsnew/2.6.html#other-language-changes">aqui</a>

Primeiro, vou mostrar como elas sempre funcionaram. Ai vai um exemplo "dummy", não levem em conta a funcionalidade em si (sou péssimo em exemplos):

{% highlight python %}
class Conta(object):
	def __init__(self, saldo = 0.0):
		self.saldo = saldo
	
	def depositar(self, valor):
		if valor > 0:
			self.saldo += valor
			return True
		return False
{% endhighlight %}

Certo, uma classe Conta, onde eu posso depositar um valor, que incrementa meu 'saldo'. Mas como ver o saldo? Os "Javeiros" de plantão perguntariam logo: "Onde está o getter do saldo?!". E eu respondo: "Não tem :-)". Simplesmente porque não precisa. Se você quiser ver o saldo, acesse o atributo direto:

{% highlight pycon %}
>>> c = Conta(100.00)
>>> print c.saldo
100.00
>>> c.depositar(20.00)
>>> print c.saldo
120.00
{% endhighlight %}

Mas isso não fere o encapsulamento? Um dos princípios básico da OO!?! É aí que entra as properties. Em Python, atributos são acessados diretamente, só se você precisar fazer algo quando acessá-lo, ai você cria um getter, e transforma o atributo numa property. Vejamos como ficaria a classe Conta:

{% highlight python %}
from datetime import datetime

class Conta(object):
	def __init__(self, saldo = 0.0):
		self._saldo = saldo
		self._ultimo_acesso = None
	
	def depositar(self, valor):
		if valor > 0:
			self._saldo += valor
			return True
		return False
	
	def _get_saldo(self):
		self._ultimo_acesso = datetime.now()
		return self._saldo
	
	saldo = property(_get_saldo)
{% endhighlight %}

Agora, ao acessar a 'property' saldo, estaremos chamando o método `_get_saldo()`. O cliente da classe continua com a mesma API. Veja que eu usei um underline (_) na frente dos atributos, isso em Python é uma convenção, pra informar que o atributo é "privado", [já que não existem atributos realmente privados](/2010/09/16/difference-between-one-underline-and-two-underlines-in-python.html).

{% highlight pycon %}
>>> c = Conta(100.00)
>>> print c.saldo
100.00
>>> print c._ultimo_acesso
2008-12-28 14:30:05.598644
{% endhighlight %}

Ou seja, getters e setters? Somente quando precisar. Confesso que depois de conhecer essa feature, dá dor na vista ler códigos em Java, PHP, etc...com vários getX, getY, getZ somente com uma linha retornando o atributo equivalente. 

Uma property é um descriptor que _conecta_ funções ao acesso a um determinado atributo. Tem a seguinte assinatura:

{% highlight python %}
property(fget=None, fset=None, fdel=None, doc=None)
{% endhighlight %}

Vamos criar um setter para a classe acima:

{% highlight python %}
def _set_saldo(self, novo_saldo):
	if novo_saldo > 0:
		self._saldo = novo_saldo

# a property agora seria
saldo = property(_get_saldo, _set_saldo)
{% endhighlight %}

Aqui vai o código na íntegra, com alguns doctests: [conta.py](/assets/uploads/conta.py).

Sim, mas o que mudou no Python 2.6? Veja como eu poderia criar o getter e setter:

{% highlight python %}
@property
def saldo(self):
    self._ultimo_acesso = datetime.now()
    return self._saldo

@saldo.setter
def saldo(self, novo_saldo):
	if novo_saldo > 0:
		self._saldo = novo_saldo
{% endhighlight %}

Aqui está o código moficado: [conta2.py](/assets/uploads/conta2.py).

Referências:

- <a href="http://www.python.org/download/releases/2.2/descrintro/">Unifying types and classes in Python 2.2</a>
- <a href="http://users.rcn.com/python/download/Descriptor.htm">How-To Guide for Descriptors</a>
