---
layout: post
title: Customizando o prompt interativo do Python
---
Acredito que todo desenvolvedor que usa Python já deve ter o <a href="http://ipython.scipy.org/moin/">ipython</a> instalado. É uma shell interativa que traz várias vantagens sob a que vem na instalação padrão do Python. Uma delas é autocompleta usando tabs.

Mas tem como configurar a shell padrão pra autocomplete com tabs, histórico (com seta pra cima), ou o que mais você quiser. 

Antes do interpretador iniciar, ele lê a variável de ambiente <a href="http://docs.python.org/using/cmdline.html#envvar-PYTHONSTARTUP">PYTHONSTARTUP</a>, e executa o conteúdo do arquivo pra onde ela aponta. Lá, você pode configurar algumas preferências pra o prompt.

Primeiro baixe esse arquivo: <a href="http://pypi.python.org/pypi/pbp.scripts">pbp.scripts</a>. 
É um conjunto de códigos usados no livro <a href="http://www.amazon.com/Expert-Python-Programming-practices-distributing/dp/184719494X">Expert Python Programming</a>,
de onde eu tirei essa dica.

Dentro desse pacote, tem o script pythonstartup.py. Renomei ele para .pythonstartup e copie para sua pasta home. No meu caso, no OS X, ficou: /Users/igorsobreira/.pythonstartup

Depois é só setar a variável de ambiente apontando pra ele

    $ export PYTHONSTARTUP=/Users/igorsobreira/.pythonstartup

Para esse export ser executado sempre que a shell do seu usuário iniciar, no OS X pode adicionar no arquivo `~/.profile`. No linux, `~/.bash_profile`.

Agora é só testar:
{% highlight python %}
>>> import sys
>>> sys.<tab><tab>
...
{% endhighlight %}

