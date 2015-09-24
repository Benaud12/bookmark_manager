require_relative '../data_mapper_setup'
require 'securerandom'
require 'sinatra/partial'

class BookmarkManager < Sinatra::Base
  register Sinatra::Partial
  set :partial_template_engine, :erb
  use Rack::MethodOverride

  enable :sessions
  set :session_secret, 'super secret'
  register Sinatra::Flash

  set :views, proc { File.join(root, '..', 'views') }

  get '/' do
    redirect ('/links')
  end

  get '/links' do
    @links = Link.all
    erb :'links/index'
  end

  post '/links' do
    link = Link.new(url: params[:url], title: params[:title])
    params[:tags].split(/\s+/).each do |name|
      tag = Tag.create(name: name)
      link.tags << tag
    end
    link.save
    redirect ('/links')
  end

  get '/links/new' do
    erb :'links/new'
  end

  get '/tags/:name' do
    tag = Tag.first(name: params[:name])
    @links = tag ? tag.links : []
    erb :'links/index'
  end

  get '/users/new' do
    @user = User.new
    erb :'users/new'
  end

  post '/users' do
    @user = User.new( email: params[:email],
                      password: params[:password],
                      password_confirmation: params[:password_confirmation])
    if @user.save
      session[:user_id] = @user.id
      redirect to('/links')
    else
      flash.now[:errors] = @user.errors.full_messages
      erb :'users/new'
    end
  end

  get '/sessions/new' do
    erb :'sessions/new'
  end

  post '/sessions' do
    user = User.authenticate(params[:email], params[:password])
    if user
      session[:user_id] = user.id
      redirect to('/links')
    else
      flash.now[:errors] = ['The email or password is incorrect']
      erb :'sessions/new'
    end
  end

  delete '/sessions' do
    session[:user_id] = nil
    flash.next[:notice] = "Goodbye!"
    redirect '/links'
  end

  get '/password_reset' do
    erb :'/users/password_reset'
  end

  post '/password_reset' do
    user = User.first(email: params[:email])
    user.password_token = SecureRandom.urlsafe_base64(32)
    user.save
    erb :'/users/check_your_email'
  end


  helpers do
    def current_user
      @current_user ||= User.get(session[:user_id])
    end
  end

end
