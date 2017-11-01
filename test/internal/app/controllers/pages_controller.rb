class PagesController < ActionController::Base
  include RailsOpentracer

  def index
    with_span 'Calling books controller from app1' do
      get('http://example.org')
    end
    @pages = Page.all
    @span
  end

end
