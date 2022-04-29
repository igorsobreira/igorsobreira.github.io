---
layout: post
title: Suprimir DeprecationWarning
---

Algumas funcionalidades estão depreciadas no Python 2.6, e como alguns módulos externos ainda não estão atualizados, DeprecationWarnings são lançados. O <a href="http://sourceforge.net/projects/mysql-python">MySQLdb</a>, por exemplo, lança o:

{% highlight pycon %}
DeprecationWarning: the sets module is deprecated
{% endhighlight %}

No meu caso, sempre que eu rodo o manage.py runserver no Django vejo esse warning, o que é bem chato. Para filtrá-lo, basta adicionar essas linhas no seu manage.py

{% highlight python %}
import warnings
warnings.simplefilter('ignore', DeprecationWarning)
{% endhighlight %}

Isso já foi resolvido na versão beta do MySQLdb, porém o Django ainda não suporta essa versão, devido a muita coisa ter sido reescrita, mas suportará na versão 1.1, <a href="http://groups.google.com/group/django-users/browse_thread/thread/c295c25b507cda57?hl=en">segundo um dos core developers</a>

Só tenha cuidado pra não filtrar todos os warnings sempre, e deixar algum aviso importante passar despercebido.
