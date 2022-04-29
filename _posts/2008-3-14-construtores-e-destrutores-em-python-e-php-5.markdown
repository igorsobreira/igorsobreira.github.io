---
layout: post
title: Construtores e Destrutores em Python e PHP 5
---

Estava aqui brincando com Orientação a Objetos no PHP 5, e não pude evitar uma comparação com Python. Percebi que os contrutores e destrutores funcionam praticamente da mesma maneira, provavelmente na maioria das linguagens deve ser assim.

Em Python o construtor é o método `__init__` da sua classe. Bem, Mark Pilgrim, autor do <a href="http://www.diveintopython.org/" target="_blank">Dive into Python</a> tem uma opinião diferente:

>"`__init__` is called immediately after an instance of the class is created. It would be tempting but incorrect to call this the constructor of the class. It's tempting, because it looks like a constructor (by convention, `__init__` is the first method defined for the class), acts like one (it's the first piece of code executed in a newly created instance of the class), and even sounds like one (“init” certainly suggests a constructor-ish nature). Incorrect, because the object has already been constructed by the time `__init__` is called, and you already have a valid reference to the new instance of the class. But `__init__` is the closest thing you're going to get to a constructor in Python, and it fills much the same role. "

Eu concordo com essa explicação, mas aqui vou chamar `__init__` de construtor mesmo.

No Python funciona assim: você tem uma classe A, e uma classe B que herda de A. Se a class A tiver o método `__init__`, mas a classe B não tiver, ao se instanciar a classe B, o interpretador vai procurar o construtor, não achando na classe atual, vai subindo para as classes base, chamando o primeiro que encontrar, no caso o da classe A. Confuso? Vejamos em código...

{% highlight python %}
class A(object):
    def __init__(self):
        print 'estou na classe A'
    
class B(A):
    pass
{% endhighlight %}

Instanciando a classe B pra ver o que acontece:

{% highlight pycon %}
>>> b = B()
estou na classe A
{% endhighlight %}

Ou seja, como a classe `B` não tinha um construtor (`__init__`), o interpretador foi subindo para as classes base até achar um, e não precisou ir muito longe, a classe `A` já tinha.

Mas se definirmos o `__init__` na classe `B`, ele vai ser executado e pára por ai:

{% highlight python %}
class A(object):
    def __init__(self):
        print 'estou na classe A'
    
class B(A):
    def __init__(self):
        print 'estou na classe B'

{% endhighlight %}

E o resultado será

{% highlight pycon %}
>>> b = B()
estou na classe B
{% endhighlight %}

Mas e se quisermos que o `__init__` da classe `A` fosse executado também? Nesse caso precisariamos chamá-lo explicitamente. Isso pode ser feito com a função `super()`

{% highlight python %}
class A(object):
    def __init__(self):
        print 'estou na classe A'
    
class B(A):
    def __init__(self):
        print 'estou na classe B'
        super(B, self).__init__()
{% endhighlight %}

E o resultado será como esperado

{% highlight pycon %}
>>> b = B()
estou na classe B
estou na classe A
{% endhighlight %}

> Atenção! Esse comportamento de construtores do Python acontece tanto para classes _old style_ quanto para classes _new style_(que herdam de object). Porém o `super()` só funciona com classes _new style_. Uma sintaxe alternativa seria: `A.__init__(self)`

A mesma coisa acontece com PHP 5 e seu construtor, o `__construct`, vejamos o mesmo exemplo

{% highlight php %}
class A {
    public function __construct() {
        echo "Estou na classe A";
    }
}
class B extends A { }

$b = new B;
{% endhighlight %}

A saída do código abaixo será:

    Estou na classe A

Mas e se definirmos o `__construct` da classe B, como chamar o da class A também? Vejamos o exemplo:

{% highlight php %}
class A {
    public function __construct() {
        echo "Estou na classe A";
    }
}
class B extends A {
    public function __construct() {
        parent::__construct();
        echo "Estou na classe B";
    }
}

$b = new B;
{% endhighlight %}

A saída será:

    Estou na classe A
    Estou na classe B

Em relação aos destrutores a idéia é a mesma. No Python seria o método `__del__`, e no PHP 5 o `__destruct`.
Um exemplo com Python:

{% highlight python %}
class A(object):
    def __init__(self):
        print 'nascendo...'
    
    def __del__(self):
        print 'morrendo........'
{% endhighlight %}

Testando...

{% highlight pycon %}
>>> a = A()
nascendo...
>>> del a
morrendo........
>>> a
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
NameError: name 'a' is not defined
{% endhighlight %}

O mesmo exemplo em PHP:

{% highlight php %}
class A {
    public function __construct() {
        echo "Nascendo..";
    }
    public function __destruct() {
        echo "Morrendo.....";
    }
}

$a = new A;
unset($a);
{% endhighlight %}

E a saida será:

    Nascendo..
    Morrendo.....
