class PagesController < ApplicationController
  include RailsOpentracer

  def index
    with_span 'Calling books controller from app1' do
      get('http://localhost:3001/books')
    end
    @users = User.all
  end

end
