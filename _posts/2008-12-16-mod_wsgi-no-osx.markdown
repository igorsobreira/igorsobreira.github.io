---
layout: post
title: mod_wsgi no OSX
---

Finalmente consegui botar o <a href="http://code.google.com/p/modwsgi/">mod_wsgi</a> pra funcionar no OSX, usando o Python 2.6.
Tive problemas compilando na mão com o Apache que já vem instalado no sistema, então resolvi instalar tudo com <a href="www.macports.org/">macports</a>.

Primeiro instalei o Python 2.5.2, depois o Python 2.6.1, deixando como default o 2.6.1. Meu medo era o comando python_select abaixo sobrescrever o python default do sistema (o /usr/bin/python), e dar problemas internos, mas o /usr/bin/python continua lá, com o 2.5.1 "mechido" pela Apple :-).

    $ sudo port install python25
    $ sudo port install python26
    $ sudo python_select python26

Pronto, agora instalar o Apache, também pelo macports

    $ sudo port install apache2
    $ sudo launchctl load -w /Library/LaunchDaemons/org.macports.apache2.plist

Se você estava usando o Apache que já vem no sistema (como eu), não esqueça de desativar em System Preferences -> Sharing.

Agora pra instalar o mod_wsgi, eu alterei algumas coisas no Portfile, já que a versão que tava lá era antiga, e pedia o Python 2.4. Seguei abaixo meu Portfile:

<a href="http://arquivos.igorsobreira.com/python/Portfile">/opt/local/var/macports/sources/rsync.macports.org/release/ports/www/mod_wsgi/Porfile</a>

É isso, um script simples pra testar se tudo tá funcionando:

{% highlight python %}
def application(environ, start_response):
    start_response('200 OK',  [('Content-type','text/plain')])
    return ['Ola mundo!\n']
{% endhighlight %}

Salve em /opt/local/apache2/htdocs/test.wsgi. 
Edite seu /opt/local/apache2/conf/httpd.conf e adicione a linha:

    WSGIScriptAlias /wsgi/test /opt/local/apache2/htdocs/test.wsgi

Basta reiniciar o Apache

    $ sudo /opt/local/apache2/bin/apachectl restart

E acessar a url <a href="/localhost/wsgi/test">/localhost/wsgi/test</a>

Tive problemas tentando compilar o mod_wsgi (com macports) com o python 2.6, e a versão padrão do sistema (com python_select) sendo o 2.5, dava uns erros com a função start_response. Mas agora tudo (aparentemente) funciona bem.
