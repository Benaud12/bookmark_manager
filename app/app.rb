require 'sinatra/base'
require_relative '../data_mapper_setup'

class BookmarkManager < Sinatra::Base

  set :views, proc { File.join(root, '..', 'views') }

  get '/links' do
    @links = Link.all
    erb :'links/index'
  end

  post '/links' do
    Link.create(url: params[:url], title: params[:title])
    redirect ('/links')
  end

  get '/links/new' do
    erb :'links/new'
  end

end
