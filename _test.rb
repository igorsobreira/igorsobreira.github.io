# frozen_string_literal: true

require 'minitest/autorun'
require 'faraday'
require 'nokogiri'

# Tests for the website
class Website < Minitest::Test
  DOMAIN = 'https://igorsobreira.github.io'

  def setup
    @http = Faraday.new(
      url: DOMAIN,
      headers: { 'User-Agent': 'igorsobreira.com test' }
    )
  end

  def test_pages
    # .html
    assert_content '/index.html', 'Igor Sobreira', 'View all posts'
    assert_content '/archive.html', 'Archive'
    assert_content '/talks.html', 'Talks'
    assert_content '/about.html', 'About'

    # no extension
    assert_content '/', 'Igor Sobreira', 'View all posts'
    assert_content '/archive', 'Archive'
    assert_content '/talks', 'Talks'
    assert_content '/about', 'About'

    assert_content '/robots.txt', 'User-agent: *'
    assert_content '/atom.xml', 'xmlns="http://www.w3.org/2005/Atom"'
    assert_content '/sitemap.xml', 'xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">'
  end

  def test_menu
    assert_menu '/', [
      { 'About' => '/about.html' },
      { 'Talks' => '/talks.html' },
      { 'Archive' => '/archive.html' }
    ]
  end

  def test_redirect_renamed_urls
    assert_github_redirect '/posts.html', '/archive.html'
  end

  def test_redirect_trailing_slash
    # In Jekyll 2, any URL constructed from the permalink: field had a
    # trailing slash (/) added to it automatically. Jekyll 3 no longer
    # adds a trailing slash automatically to permalink: URLs. This can
    # potentially result in old links to pages returning a 404 error.
    assert_github_redirect '/about/', '/about.html'
    assert_github_redirect '/archive/', '/archive.html'
    assert_github_redirect '/talks/', '/talks.html'
  end

  private

  # Asserts that a given URL has one or more text snippets
  def assert_content(path, *snippets)
    resp = @http.get(path)
    assert_response_status resp, 200
    snippets.each { |snippet| assert_response_snippet(resp, snippet) }
  end

  # Assert URL `origin` redirects to `target` in Github pages
  #
  # Github pages return 200 with <meta http-equiv="refresh">
  def assert_github_redirect(origin, target)
    resp = @http.get(origin)
    assert_response_status resp, 200
    assert_response_meta_refresh resp, get_url(target)
  end

  # Assert that a given URL has <nav> with <a>s
  def assert_menu(path, menu_items)
    resp = @http.get(path)
    assert_response_status resp, 200
    assert_response_nav_links resp, menu_items
  end

  def assert_response_status(resp, status)
    assert_equal status, resp.status, "Expected status 200 on #{resp.env.url} but got #{resp.status}"
  end

  # Assert response body contain text snippet
  def assert_response_snippet(resp, snippet)
    assert_includes resp.body, snippet, "Expected #{resp.env.url} body to contain #{snippet.inspect}"
  end

  # Assert the presence of a <meta http-equiv="refresh"> tag, where `target` is the URL
  # being redirected to
  def assert_response_meta_refresh(resp, target)
    html = Nokogiri::HTML.parse(resp.body)

    meta = html.xpath('//meta[@http-equiv="refresh"]').first
    refute_nil meta, "No <meta http-equiv=\"refresh\"> found in #{resp.env.url}"

    assert_equal 'content', meta.attributes['content'].name
    assert_equal "0; url=#{target}", meta.attributes['content'].value
  end

  def assert_response_nav_links(resp, items)
    html = Nokogiri::HTML.parse(resp.body)
    links = html.xpath('//nav//a')

    found = []
    links.each do |a|
      found << { a.text => a.attributes['href'].value }
    end

    assert_equal items, found
  end

  def get_url(path)
    DOMAIN + path
  end
end
