require 'minitest/autorun'
require 'faraday'
require 'nokogiri'


class Website < Minitest::Test

  DOMAIN = 'https://igorsobreira.github.io'

  def setup
    @http = Faraday.new(
      url: DOMAIN,
      headers: {'User-Agent': 'igorsobreira.com test'}
    )
  end
  
  def test_pages
    # .html
    assert_content '/index.html', 'Igor Sobreira', 'View all posts'
    assert_content '/archive.html', 'Archive'
    assert_content '/talks.html', 'Talks'
    assert_content '/about.html', 'About'

    # / 
    assert_content '/', 'Igor Sobreira', 'View all posts'
    assert_content '/talks/', 'Talks'
    assert_content '/archive/', 'Archive'
    assert_content '/about/', 'About'

    assert_content '/robots.txt', 'User-agent: *'
    assert_content '/atom.xml', 'xmlns="http://www.w3.org/2005/Atom"'
    assert_content '/sitemap.xml', 'xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">'
  end

  def test_menu
    # TODO: test menu items
  end

  def test_posts
    # TODO: test link to posts in homepage
  end

  def test_redirects
    assert_github_redirect '/posts.html', '/archive.html'
  end

  private 

  def assert_content(path, *snippets)
    resp = @http.get(path)
    assert_status resp, 200
    snippets.each { |snippet| assert_snippet(resp, snippet) }
  end

  # Assert URL `origin` redirects to `target` in Github pages
  #
  # Github pages return 200 with <meta http-equiv="refresh">
  def assert_github_redirect(origin, target)
    resp = @http.get(origin)
    assert_status resp, 200
    assert_meta_refresh resp, get_url(target)
  end

  def assert_status(resp, status)
    assert_equal status, resp.status, "Expected status 200 on #{resp.env.url.to_s} but got #{resp.status}"
  end

  # Assert response body contain text snippet
  def assert_snippet(resp, snippet)
    assert_includes resp.body, snippet, "Expected #{resp.env.url.to_s} body to contain #{snippet.inspect}"
  end

  # Assert the presence of a <meta http-equiv="refresh"> tag, where `target` is the URL
  # being redirected to
  def assert_meta_refresh(resp, target)
    html = Nokogiri::HTML.parse(resp.body)

    meta = html.xpath('//meta[@http-equiv="refresh"]').first
    refute_nil meta, "No <meta http-equiv=\"refresh\"> found"

    assert_equal "content", meta.attributes["content"].name
    assert_equal "0; url=#{target}", meta.attributes["content"].value
  end

  def get_url(path)
    DOMAIN + path
  end
end