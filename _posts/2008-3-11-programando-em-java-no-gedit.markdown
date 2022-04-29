---
layout: post
title: Programando em Java no Gedit
---

Pois é, aqui estou eu programando em Java...esse período estou pagando uma cadeira de de POO, e <s>infelizmente</s> é com Java. Na verdade meu curso é quase todo em Java.

Mas eu uso o Gedit pra programar, e agora? Instalar o Eclipse ou ou alguma outra IDE? Por enquanto não. Existe um plugin no Gedit chamado <a href="http://live.gnome.org/Gedit/ToolLauncherPlugin">External Tools</a>, que já vem nele, talvez precise habilitar em Edit -> Preferences -> Plugins. Com ele você pode executar códigos externos. Como por exemplo compilar e executar um arquivo em java.

Pra compilar vá em Tools -> External Tools, e adicione um novo, no comando adicione:

{% highlight bash %}
echo "Compiling: " $GEDIT_CURRENT_DOCUMENT_PATH
javac $GEDIT_CURRENT_DOCUMENT_PATH
{% endhighlight %}

Pode botar uma tecla de atalho se quiser.

E pra executar o código, eu fiz um script em python, e adicionei no diretório: `~/.gedit/java_run.py`. Segue o código **Atualizado em 13/03**:

{% highlight python %}
#!/usr/bin/python
import sys
from os import system, chdir

if len(sys.argv) != 3:
    print "Can't run program"
    sys.exit(0)

chdir(sys.argv[1])
command = 'java %s' % sys.argv[2].replace('.java','')
system(command)
{% endhighlight %}

E adicione um novo "External Tool" com o seguinte código:

{% highlight bash %}
#Runs a compiled Java source file.
echo "Running: " $GEDIT_CURRENT_DOCUMENT_PATH
echo '--------------------'
python ~/.gedit/java_run.py $GEDIT_CURRENT_DOCUMENT_DIR  $GEDIT_CURRENT_DOCUMENT_NAME
{% endhighlight %}

Pronto. Agora o Gedit é <i>quase</i> uma IDE Java. :)
