---
layout: post
title: Testing infinite loops
---

Yesterday I was working on a script that should run forever, or at least until the user stops it. The library behind it was already tested except for this little function:

    def collect(directory):
        sequential = Sequential(directory)
        live = Live(directory)

        while 1:
            live.process()
            sequential.process()

this is the entry point of my library. I have an executable that just parses a directory name from command line and call this function. It's purpose it to collect all files from a directory, filter based on some rules, and publish the file names in a queue which will be consumed by another script. It runs forever because newly created files are detected and collected too.

Anyway, what it does doesn't really matter, the problem is: how to test this function since it's supposed to run forever?

I don't mind to have just unit tests for this function because I already have more integration-like tests for the classes it uses. The first solution I thought was something like this:

    def collect(directory):
        sequential = Sequential(directory)
        live = Live(directory)

        while should_continue():  # new function to mock on tests: UGLY!
            live.process()
            sequential.process()

    def should_continue():
        return True

this way I could mock `should_continue()` in my test and make it return `False` to abort the loop when I want. That works but it's ugly! **I don't like to add dependency injections only for tests**.

I asked on #python on irc and marienz gave a neat idea: raise an exception.
I could mock `live.process()` and `sequential.process()` and raise an exception, this way I know they were called as I expected and also it will also abort the loop!

    import pytest
    import mock

    # this is the library under test
    import collectors

    # replace original classed with mock objects
    @mock.patch('collectors.Sequential')
    @mock.patch('collectors.Live')
    def test_collect_should_loop_forever_processing_both_collectors(
            collectors_Live, collectors_Sequential):

        # build mock instances. process() method will raise error
        # when called for the 2nd time. The code for `ErrorAfter`
        # is bellow
        seq = mock.Mock(['process'])
        seq.process.side_effect = ErrorAfter(2)
        live = mock.Mock(['process'])
        live.process.side_effect = ErrorAfter(2)

        # ensure mocked classes builds my mocked instances
        collectors_Sequential.return_value = seq
        collectors_Live.return_value = live

        # `ErrorAfter` will raise `CallableExhausted`
        with pytest.raises(CallableExhausted):
            collectors.collect('/tmp/files')
        
        # make sure our classed are instantiated with directory
        collectors_Sequential.assert_called_once_with('/tmp/files')
        collectors_Live.assert_called_once_with('/tmp/files')

This test uses [py.test](http://pytest.org/) and [mock](http://www.voidspace.org.uk/python/mock/). I hope the comments explains enough. The idea is simple: make `process()` raise an Exception to abort the loop.
The `ErrorAfter` class is a small helper, it builds a callable object that will raise a specific exception after `n` calls. I created a custom exception here to make sure my test fails if any other exception is raised. See the code bellow.

    class ErrorAfter(object):
        '''
        Callable that will raise `CallableExhausted`
        exception after `limit` calls

        '''
        def __init__(self, limit):
            self.limit = limit
            self.calls = 0

        def __call__(self):
            self.calls += 1
            if self.calls > self.limit:
                raise CallableExhausted

    class CallableExhausted(Exception):
        pass


### Conclusion

Try to avoid as much as possible to create dependency injections specifically for your tests. In dynamic languages like Python it's very easy to replace a specific component with a mock object without adding extra complexity to your code just to allow unit testing.

This was the first time I had to test a infinite loop, it's possible and easy!
