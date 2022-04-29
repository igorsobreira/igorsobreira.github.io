---
layout: post
title: Mocks, Stubs, Fakes and Spies
---

Reading the <a href="http://continuousdelivery.com/">Continous Delivery</a> book I found a good definition of mocks, fakes, stubs and spies:

- "Fake objects actually have working implementations, but usually take some shortcut which makes them not suitable for production. A good example of this is the in-memory database.
- Stubs provide canned answers to calls made during the test, usually not responding at all to anything outside what’s programmed in for the test.
- Spies are stubs that also record some information based on how they were called. One form of this might be an email service that records how many messages it was sent.
- Mocks are pre-programmed with expectations which form a specification of the calls they are expected to receive. They can throw an exception if they receive a call they don’t expect and are checked during verification to ensure they got all the calls they were expecting."

This terminology was taken from <a href="http://www.amazon.com/xUnit-Test-Patterns-Refactoring-Code/dp/0131495054">xUnit Test Patterns</a> book.

I've already seen cases where people write lot's of unit tests, abusing from mock objects, but without good integration and acceptance tests you can't really guarantee that each scenario is really working as expected.

>"It’s very easy to misuse mocks to write tests that are both pointless and fragile, using them simply to assert the specific details of the workings of some code, rather than an assertion of interactions with collaborators."

A couple links if you want to read more about it:

- <a href="http://www.jmock.org/oopsla2004.pdf">Mock Roles, Not Object</a>
- <a href="http://martinfowler.com/articles/mocksArentStubs.html">Mocks Aren't Stubs</a>
