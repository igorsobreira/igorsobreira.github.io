#!/bin/bash


function install {
    bundler --version 1>&- 2>&- || (
        echo "Bundler not installed" &&
        gem install bundler
    )
    bundle install
}

function serve {
    bundle exec jekyll serve
}

function test {
    bundle exec ruby _test.rb
}


if [ -z "$1" ]; then
    echo "missing command"
    exit 1
else
    $@
fi