---
layout: post
title: Python coverage threshold
---

Ned Batchelder committed a new feature to coverage.py 2 days ago, it's a way to verify coverage threshold. Basically a way to fail your tests if the coverage is not enough.
For now you need to install from the repository to get the new feature

    $ pip install hg+https://bitbucket.org/ned/coveragepy#egg=coverage

This is how to use from the command line:

    $ coverage run run_my_tests.py 
    ... running all tests
    $ coverage report --fail-under=100
    ... display the report
    $ echo $?
    2

If your coverage is not 100% your exit status will be 2. This will make your CI fail if your coverage is not enough :).
You can also verify coverage using the python API, in this case you need to verify the return value from `report()` function, here is an example:

    cov = coverage.coverage(..)
    cov.start()
    ret = run_all_my_tests()
    cov.stop()
    if ret == 0:
        covered = cov.report()
        assert covered > 100, "Not enough coverage"
    ...

I've created a decorator to make this easier:

    def ensure_coverage(percentage, **cov_options):
        def decorator(function):
            @wraps(function)
            def wrapper(*args, **kw):
                cov = coverage.coverage(branch=True, **cov_options)
                cov.start()
                ret = function(*args, **kw)
                cov.stop()
                if ret == 0:
                    covered = cov.report()
                    assert covered >= percentage, \
                        "Not enough coverage: {0:.2f}%. You need at least {1}%".format(covered, percentage)
                return ret
            return wrapper
        return decorator

This is an usage example for this django app I'm working on:

    @ensure_coverage(99, source=['filecabinet'], omit=['filecabinet/tests/*'])
    def runtests():
        test_runner = get_runner(settings)()
        return test_runner.run_tests(['filecabinet'])

    if __name__ == '__main__':
        sys.exit(runtests())

Here are the related commits, if you're interested:

[https://bitbucket.org/ned/coveragepy/changeset/7ea709fc4c1190cf0ffe0aba1a49e6fffe683d2f](https://bitbucket.org/ned/coveragepy/changeset/7ea709fc4c1190cf0ffe0aba1a49e6fffe683d2f)
[https://bitbucket.org/ned/coveragepy/changeset/90014f4defd336f05851bdfc01c2b5af60a933c9](https://bitbucket.org/ned/coveragepy/changeset/90014f4defd336f05851bdfc01c2b5af60a933c9)
[https://bitbucket.org/ned/coveragepy/changeset/ba7267fe525001dba99ed1c2c9d11f0724ad9950](https://bitbucket.org/ned/coveragepy/changeset/ba7267fe525001dba99ed1c2c9d11f0724ad9950)

And the discussion on the issue:

[https://bitbucket.org/ned/coveragepy/issue/139/easy-check-for-a-certain-coverage-in-tests](https://bitbucket.org/ned/coveragepy/issue/139/easy-check-for-a-certain-coverage-in-tests)
