class PagesController < ActionController::Base
  include RailsOpentracer

  def index
    with_span 'example of an http request' do
      get('http://example.org')
    end
    @pages = Page.all
    @span
  end
end
