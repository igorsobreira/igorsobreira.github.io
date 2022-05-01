---
layout: post
title: Ajax File Upload with jQuery
---

I've been looking for an Ajax upload plugin for jQuery yesterday. And actually I found some interesting solutions, but any of then did what I wanted.

I needed a multi file upload. I had a form with many file inputs and I wanted it to just works, using Ajax. The options available that supports multi file upload (without flash), are limited to just one file input, and you can choose more that one file from it. It's nice, but not what I needed.

Then I found this one: <a href="http://www.phpletter.com/Our-Projects/AjaxFileUpload/">Ajax File Upload</a>. It only supports one file input too, but I've hacked it to support more that one, and still be able to send more data (the other fields values of my form) to the server.

Internally it creates a new form, and put it inside an iframe, and so on. Well, it just works, and it was easy to modify for my needs.

## Usage

{% highlight javascript %}
$.ajaxFileUpload({
    url : '/url/to/post/',

    // here you pass a jQuery selector with all your file inputs.
    // this is the main change I've made, in the original version you had to pass an
    // ID of you file input
    fileElements : $('input[type=file]'),

    // also supports json, xml and script
    dataType : 'html',

    success : function(response) {
        alert('hey, it worked')
    },
    error : function(xhr, status, error) {
        alert("you've got a problem here")
    },

    // here you pass an object with all extra data you want to send.
    // it didn't existed in the original version
    extraData : {foo: 'bar'}
});
{% endhighlight %}

## Download
You can download it <a href="http://arquivos.igorsobreira.com/javascript/ajaxfileupload.js">here</a>. And the original can be found <a href="http://www.phpletter.com/Our-Projects/AjaxFileUpload/">here</a>, you will find more usage examples there too.

If you're insterested, <a href="http://arquivos.igorsobreira.com/javascript/ajaxfileupload.diff">here</a> is the diff with my changes.

I hope it's useful for you too.