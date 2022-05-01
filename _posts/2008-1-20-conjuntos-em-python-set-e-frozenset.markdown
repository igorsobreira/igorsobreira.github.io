---
layout: post
title: Conjuntos em Python - set e frozenset
---

Os conjuntos são um tipo de dados do python que nunca ouvi falar muito. Eu particularmente nunca usei, mas dando uma olhada agora vi que são muito interessantes.

Uma coisa que eu precisei fazer ontem foi retirar dados repedidos de uma lista, e não existe um método de lista que faça isso. Já nos conjuntos isso é automático, não existem dados repetidos.

A diferença entre <b>set</b> e <b>frozenset</b>, é que o primeiro é mutável, já o segunto não.
Criando um conjunto...

{% highlight python %}
>>> conjunto1 = set('12345')
>>> conjunto1
set(['1', '3', '2', '5', '4'])
>>> 
{% endhighlight %}

Veja que é passado um tipo iterável para o set(nessa caso uma string), onde cada elemento vai ser um elemento do conjunto.
 
{% highlight python %}
>>> conjunto2 = set([4,4,7,7,8,9])
>>> conjunto2
set([8, 9, 4, 7])
{% endhighlight %}

Veja que realmente ele não permite elementos repetidos.
Você deve ter percebido que os elementos não estão na mesma ordem que foram passados. Isso porquê conjuntos realmente não possuem nenhuma ordem. São <b>iteráveis</b>, ou seja, podemos fazer `for x in meu_conjunto`, `len(meu_conjunto)`, `x in meu_conjunto`. Mas como eles <b>não possuem ordem</b>, não é permitido indexação, nem slicing, algo tipo `meu_conjunto[2:]` está errado.

Mas vamos a algumas operações entre conjuntos.

**Está contido e contém**

{% highlight python %}
>>> conjunto1.issubset(conjunto2)
False
>>> conjunto1.issubset(set('123456789'))
True
>>>
{% endhighlight %}

Também podemos usar os operadores

{% highlight python %}
>>> conjunto1 <= set('123456789')
True
>>> set('123456789') >= conjunto1
True
{% endhighlight %}

**União**

{% highlight python %}
>>> conjunto1.union(conjunto2)
set([4, 7, 8, 9, '1', '3', '2', '5', '4'])
>>> conjunto1 | conjunto2
set([4, 7, 8, 9, '1', '3', '2', '5', '4'])
{% endhighlight %}

**Interseção**

{% highlight python %}
>>> set('123').intersection(set('345'))
set(['3'])
>>> set('123') & set('345')
set(['3'])
{% endhighlight %}

**Diferença**

{% highlight python %}
>>> set('1234').difference(set('3'))
set(['1', '2', '4'])
>>> 
>>> set('1234') - set('34')
set(['1', '2'])
>>> 
{% endhighlight %}

Operações entre sets e frozensets são permitidas, mas veja que a ordem em que eles aparecem importa

{% highlight python %}
>>> set('234') | frozenset('45')
set(['3', '2', '5', '4'])
>>> frozenset('23') | set('567')
frozenset(['3', '2', '5', '7', '6'])
{% endhighlight %}

Outra coisa importante, é que podemos passar iteráveis tanto na criação do set como nas operações usando os métodos. Mas as operações usando os operadores devem ser obrigatoriamente entre sets:

{% highlight python %}
>>> set('234').union([5,6])
set(['3', '2', '4', 6, 5])
>>> 
>>> set('234') | [2,3]
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: unsupported operand type(s) for |: 'set' and 'list'
>>> 
{% endhighlight %}

Os sets, por serem mutáveis, também possuem métodos que adicionar e remover novos elementos. Como os frozensets são imutáveis, não possuem esse métodos

{% highlight python %}
>>> conjunto1 = set(['a','b','c','d'])
>>> conjunto1
set(['a', 'c', 'b', 'd'])
>>> conjunto1.update(set('nada'))
>>> conjunto1
set(['a', 'c', 'b', 'd', 'n'])
>>> 
{% endhighlight %}

O `conjunto.update(outro_conjunto)`, atualiza `conjunto` adicionando os elementos de `outro_conjunto`. Tem também os métodos `set.add(x)`, `set.remove(x)`, `set.pop()`, `set.clear()`. Além do `set.discard(x)`, que só remove o elemento se ele existir, diferente do `remove()` que retorna `KeyError` caso o elemento não exista.

O exemplo que eu citei no começo, de retirar dados repetidos de uma lista poderia ter sido feito assim:

{% highlight python %}
>>> numeros = [2,5,3,2,1,6,3,5,2,2]
>>> list( set(numeros) )
[1, 2, 3, 5, 6]
{% endhighlight %}

Simples não?

Veja mais detalhes sobre conjuntos <a href="http://docs.python.org/lib/types-set.html">aqui</a>
