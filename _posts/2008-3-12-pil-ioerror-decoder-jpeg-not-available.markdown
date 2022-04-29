---
layout: post
title: PIL - IOError - decoder jpeg not available
---

Eu estava com um problema com a <a href="http://www.pythonware.com/products/pil/">PIL</a>, o módulo pra manipulação de imagens do python, sempre que tentava manipular uma imagem .jpg recebia esse erro:

    IOError: decoder jpeg not available

O problema é que tava faltando a <i>libjpeg</i>, mas mesmo depois que eu instalei, nao tinha dado certo porque não tinha removido a instalação atual da PIL, então vou botar os passos aqui que finalmente  fez a coisa funcionar no Debian e Ubuntu.

Primeiro remover a PIL que ta dando erro (como root):

    # rm -rf /usr/lib/python2.5/site-packages/PIL
    # rm -rf /usr/lib/python2.5/site-packages/PIL.pth 
    # rm -rf Imaging-1.1.6  # onde quer que tenha instalado

Agora instalar a libjpeg

    # aptitude install libjpeg libjpeg-dev
    # aptitude install  libfreetype6 libfreetype6-dev

Baixar novamente a PIL, e instalar

    # wget http://effbot.org/media/downloads/Imaging-1.1.6.tar.gz
    # tar xvzf Imaging-1.1.6.tar.gz
    # cd Imaging-1.1.6
    # python setup.py build_ext -i

Rodar os testes pra verificar se realmente não tem problemas

    # python selftest.py 

e instalar

    # python setup.py install

É isso ai.
