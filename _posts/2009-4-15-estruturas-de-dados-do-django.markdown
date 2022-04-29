---
layout: post
title: Estruturas de dados do Django
---

O <a href="http://djangoproject.com/">Django</a> tem um módulo com algumas estruturas de dados bem úteis, que ele usa internamente. Fica em <a href="http://code.djangoproject.com/browser/django/trunk/django/utils/datastructures.py">django.utils.datastructures</a>.

Uma delas é a <a href="http://code.djangoproject.com/browser/django/trunk/django/utils/datastructures.py#L53">SortedDict</a>, como o nome mesmo já diz, é um dicionário que mantém as chaves ordenadas. Já vi muita gente perguntando como ordenar os itens de um dicionário, taí um jeito. 

Ele faz isso herdando de dict e mantendo uma lista interna (keyOrder) com a ordem real das chaves. Não é algo complicado de se fazer, mas já ter lá pronta pra usar é uma mão na roda. O dicionários de campos (self.fields) dos formulários do Django são instâncias de SortedDict, por exemplo.

Outra bem interessante é a <a href="http://code.djangoproject.com/browser/django/trunk/django/utils/datastructures.py#L170">MultiValueDict</a>, um dicionário onde cada chave pode ter mais de um valor. 	

Bem, fica a dica! Um bom começo, pra quem usa Django, pra começar a dar uma fuçada nos fontes.