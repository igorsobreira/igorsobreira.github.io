---
layout: post
title: Command line interface to FMS Admin
---

I've been working with Flash Media Server for the last 8 months now, and one tool that really annoys me is the Administration Console. I miss a command line interface to accomplish tasks like see all live streams, reload an app, etc.

That's why I've started the <a href="https://github.com/igorsobreira/fms-admin-api/">fms-admin-api</a>. It's a command line client to <a href="http://help.adobe.com/en_US/flashmediaserver/adminapi/WSa4cb07693d12388431df580a12a34991ebc-8000.html">Flash Media Server Administration API</a>. Since it's written in ruby, it's possible to use the ruby client class directly. Use rubygems to install:

    $ gem install fms-admin-api

The way it works is really simple. Here is an example: there is a reloadApp() method available that accepts the arguments host, auser, apswd and appInst. The command line interface just replaces from camelCase syntax to underscore:

    $ fmsapi reload_app --host=fms.example.com --auser=fms --apswd=secret --app_inst=live

There are [improvements](https://github.com/igorsobreira/fms-admin-api/issues?sort=created&direction=desc&state=open) to be made and help is welcome.