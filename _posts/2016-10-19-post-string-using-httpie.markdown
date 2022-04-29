---
layout: post
title: Posting strings using HTTPie
---

Some time ago I came across this great command line tool to make http requests: [HTTPie](https://httpie.org/). Simple and intuitive API:

    http PUT example.org X-API-Token:123 name=Igor

this sends that `PUT` as JSON. To submit as form (`application/x-www-form-urlencoded; charset=utf-8`), just set the `-f` flag.

Now it took me some time to figure out how to send a raw string as body. It turns out you can just [write to it's stdin](https://github.com/jkbrzt/httpie#redirected-input):

    echo '{"name":"Igor"}' | http PUT example.org

Nice API.
