---
layout: post
title: MySQL-python no Mac OS
---

<a href="http://sourceforge.net/projects/mysql-python/">MySQL-python</a> é o módulo que o Python usa para se conectar a bancos MySQL. Tive um probleminha pra instalar ele aqui no Mac OS, mas é um bug conhecido, e já tem a solução no <a href="http://www.google.com">oráculo</a>. Mas vou documentar aqui também.

Primeiro, <a href="http://sourceforge.net/project/showfiles.php?group_id=22307&package_id=15775&release_id=491012">baixar o  pacote</a>. E descompactar:

    $ tar xvzf MySQL-python-1.2.2.tar.gz
    $ cd MySQL-python-1.2.2

Se você não tiver o `mysql_config` no PATH, é preciso editar o setup-posix.py, onde tiver

    mysql_config.path = "mysql_config"

mudar para o caminho completo

    mysql_config.path = "/usr/local/mysql/bin/mysql_config"

Caso ainda retorne o erro:

    In file included from /usr/local/mysql/include/mysql.h:47,
                     from _mysql.c:40:
    /usr/include/sys/types.h:92: error: duplicate 'unsigned'
    /usr/include/sys/types.h:92: error: two or more data types in declaration specifiers
    error: command '/usr/bin/gcc-4.0' failed with exit status 1

Basta comentar, no arquivo _mysql.c, a linha 

    #define uint unsigned int

Agora é só instalar

    $ sudo python setup.py install
