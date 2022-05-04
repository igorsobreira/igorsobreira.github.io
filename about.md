---
layout: page
title: About
---

Contact me by email at <b>igor</b> @ <i>this domain</i>.

Or find me on social networks

<ul>
{% for link in site.social.links %}
<li><a href="{{ link }}">{{ link }}</a></li>
{% endfor %}
</ul>