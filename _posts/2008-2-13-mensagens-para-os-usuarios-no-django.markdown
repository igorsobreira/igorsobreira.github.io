---
layout: post
title: Mensagens para os usuários no Django
---
Ultimamente tenho usado muito a <a href="http://www.djangoproject.com/documentation/authentication/">aplicação de autenticação do Django</a>. Mas não estava muito satisfeito com o <a href="http://www.djangoproject.com/documentation/authentication/#messages">sistema de mensagens</a> para os usuários que é oferecido. Na verdade a intenção é ser realmente bem simples, vejamos um exemplo:

{% highlight python %}
def alterar_foto(request):
    # executa o código da view aqui....
    request.user.message_set.create(message=u'Foto alterada')
    return render_to_response('usuarios/dados.html',
                              context_instance=RequestContext(request))
{% endhighlight %}

Foi adicionado uma mensagem para o usuário, assim podemos criar uma fila das últimas ações executadas pelo mesmo. Só que o método para acessar essas mensagens é o <a href="http://code.djangoproject.com/browser/django/trunk/django/contrib/auth/models.py#L277">get_and_delete_messages()</a>:

{% highlight python %}
mensagens = user.get_and_delete_messages()
{% endhighlight %}

e no template, assumido que esteja usando <a href="http://www.djangoproject.com/documentation/templates_python/#subclassing-context-requestcontext">RequestContext</a>, ficaria assim:

{% highlight django %}
<ul>
{{ "{% for message in messages "}}%}
    <li>{{ "{{ message " }}}}</li>
{{ "{% endfor "}}%}
</ul>
{% endhighlight %}

pois o <a href="http://www.djangoproject.com/documentation/templates_python/#subclassing-context-requestcontext">RequestContext</a> define no template a variável messages, que são as mensagens do usuário logado.
Mas como o próprio nome do método já diz, quando as mensagen são acessadas, elas são removidas. Eu não gostei muito disso, pelo fato de o usuário só poder ver as últimas ações uma única vez, além de que não tem um campo de data no model <a href="http://code.djangoproject.com/browser/django/trunk/django/contrib/auth/models.py#L306">Message</a>, pra mostrar o dia e hora daquela ação.

Daí decidi reinventar a roda, e fazer um sisteminha de mensagens com essas características.
Eu fiz as mensagens acopladas a um perfil que eu criei pra o usuário do django, e não vou detalhar como se criar um perfil para seu User, veja mais <a href="http://www.djangobook.com/en/beta/chapter12/">aqui(lá no final do capítulo)</a> e <a href="http://www.b-list.org/weblog/2006/jun/06/django-tips-extending-user-model/">aqui</a>.

Bem, basicamente é esse model:

{% highlight python %}
class Action(models.Model):
    user = models.ForeignKey(UserProfile)
    action = models.CharField(max_length=200)
    pub_date = models.DateTimeField(auto_now_add=True)

    def __unicode__(self):
        return self.action

    class Meta:
        ordering = ('-pub_date',)
        db_table = 'auth_user_profile_action'
{% endhighlight %}

Onde a classe `UserProfile`, é minha classe que extende o User da aplicação contrib.auth do Django.
Daí eu adicionei um método na classe `UserProfile`:

{% highlight python %}
from django.contrib.auth.models import User

class UserProfile(models.Model):
    # meus campos extras
    user = models.ForeignKey(User, unique=True)

    # mais alguns método aqui, como o __unicode__, a class Meta, class Admin, etc

    def keep_actions(self, maximum=10):
        actions = self.action_set.count()
        if actions > maximum:
            extras = self.action_set.all()[maximum:actions]
            for extra in extras:
                extra.delete()
{% endhighlight %}

A intenção é a seguinte: sempre ter um número máximo de 'ultimas ações' do usuário, então esse método `keep_settings()` recebe um parâmatro opcional(valor default é 10), que vai ser o número máximo de ações que ele vai permitir na tabela. É mais um método pra "limpar" as ações antigas.

Um exemplo de uso:

{% highlight python %}
def adicionar_foto(request):
    # codigo normal da view...
    profile = request.user.get_profile()
    profile.action_set.create(action=u'Foto adicionada')
    profile.keep_actions()
    profile.save()
    # termina a view normalmente....
{% endhighlight %}

Aí eu adiciono uma ação relacionada com meu usuário, e o método `keep_settings()` vai garantir que terá no máximo 10 "ultimas ações", caso tenha mais de 10, ele remove as mais antigas e deixa apenas as 10 mais recentes.

E no template ficaria assim:

{% highlight django %}
<ul>
{{ "{% for action in request.user.get_profile.action_set.all " }}%}
    <li>{{ "{{ action.pub_date|date:'d/m/Y H:i' "}}}} - {{ "{{ action " }}}}</li>
{{ "{% endfor "}}%}
</ul>
{% endhighlight %}

Assim eu mostro a hora que a ação foi executada e deixo sempre um histórico de 10 ou mais últimas ações. Pra deletar todas poderia chamar o método `keep_actions(0)` passando zero como parâmetro.
