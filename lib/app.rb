class Application < Sinatra::Base
  set      :views,                File.dirname(__FILE__) + "/../views"
  set      :public_folder,        File.dirname(__FILE__) + "/../public"
  use      Rack::Session::Cookie, secret: '$2a$10$ZKMiSw22/QOXgBvt8sHEPuNyExwwssLAXIDmVHQlGWQ.9kvzJK0Qi'
  use      Rack::Flash,           sweep:  true
  use      Warden::Manager do |manager|
    manager.default_strategies :email_and_password
    manager.failure_app = Application
  end
  register Warden

  helpers do
    include Rack::Utils
    alias_method :h, :escape_html
  end

  before %r{^(\/me)} do
    authenticate_user!
  end

  get '/' do
    if user_signed_in?
      redirect '/me'
    else
      haml :welcome
    end    
  end

  get '/me' do
    @references = current_user.references #TODO: includes(:link)??
    haml :user
  end

  get '/me/link/new' do
    haml :new_link
  end

  post '/me/link/create' do
    unless current_user.references_url?(params[:url])
      @link = Link.where(url: params[:url]).first    
      if @link.nil?
        @link = Link.new(params) 
      end
      
      @reference = current_user.references.new(link: @link)
      if @link.save and @reference.save
        redirect '/me'
      else
        flash[:error] = 'An error ocurred while saving your link. Please try again later.'
        haml :new_link
      end
    else
      flash[:notice] = 'Link was alrady referenced.'
      redirect '/me'
    end
  end

  get '/signin' do
    haml :signin
  end

  post '/unauthenticated' do
    flash[:alert] = 'The given credentials are not valid.'
    haml :signin
  end

  post '/session/create' do
    env['warden'].authenticate!

    redirect_back_url = session.delete(:redirect_back)

    flash[:success] = 'You successfully signed in.'
    redirect redirect_back_url || '/me'
  end

  get '/session/destroy' do #TODO: put under the auth filter
    env['warden'].logout
    flash[:success] = 'You successfully signed out.'
    redirect '/'
  end

  protected
  def user_signed_in?
    env['warden'].authenticated?
  end

  def current_user
    env['warden'].user
  end

  private
  def authenticate_user!
    unless user_signed_in?
      session[:redirect_back] = request.path unless request.path == '/signin'
      flash[:notice] = 'You must signin!'
      redirect '/signin'
    end
  end
end