---
layout: post
title: Campos numéricos localizados no Django
---

A criação de campos numéricos ficou muito <a href="http://docs.djangoproject.com/en/1.2/topics/i18n/localization/#format-localization">mais fácil no Django na versão 1.2</a>. Imagine o seguinte model:

{% highlight python %}
class Debito(models.Model):
    descricao = models.CharField(max_length=256)
    valor = models.DecimalField(max_digits=10, decimal_places=2)
    
    def unicode(self):
        return self.descricao
{% endhighlight %}

E seu registro no admin

{% highlight python %}
admin.site.register(Debito)
{% endhighlight %}

Ao tentar cadastrar um valor numérico, por exemplo: 1.450,60, receberíamos um erro já que esse formato não era entendido como numérico. Agora, basta informar que esse campo precisa ser localizado. Como isso é feito no formulário, e não no model, vamos sobrescrever o formulário padrão do admin

{% highlight python %}
class DebitoForm(forms.ModelForm)
    valor = forms.DecimalField(max_digits=10, decimal_places=2, localize=True)

    class Meta:
        model = Debito

class DebitoAdmin(admin.ModelAdmin):
    form = DebitoForm

admin.site.register(Debito, DebitoAdmin)
{% endhighlight %}

Note o parâmetro `localize` no campo `DecimalField` do formulário.

Estamos quase lá, só precisamos nos certificar de que as seguintes configurações estão no settings.py

{% highlight python %}
USE_L10N = True         # essa é padrão
USE_THOUSAND_SEPARATOR = True
{% endhighlight %}

Mas ainda tem um detalhe, se você tentar acessar `debito.valor` vai receber uma instância da classe `decimal.Decimal` do python, e ainda terá que formatar manualmente. Felizmente o django já possui uma função pra fazer isso. Para facilitar, você pode adicionar um método no seu model:

{% highlight python %}
from django.utils.formats import number_format

class Debito(models.Model):
    descricao = models.CharField(max_length=256)
    valor = models.DecimalField(max_digits=10, decimal_places=2)

    def __unicode__(self):
        return self.descricao

    @property
    def valor_formatado(self):
        return u"R$ %s" % number_format(self.valor, 2) 
{% endhighlight %}

Agora sim, basta acessar `debito.valor_formatado`.

Confira <a href="http://docs.djangoproject.com/en/1.2/topics/i18n/localization/#format-localization">a documentação para mais detalhes</a>.

Até a próxima!