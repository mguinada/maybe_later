require 'rack/conneg'

class Application < Sinatra::Base
  set      :views,                File.dirname(__FILE__) + "/../views"
  set      :public_folder,        File.dirname(__FILE__) + "/../public"
  use      Rack::Session::Cookie, secret: '$2a$10$ZKMiSw22/QOXgBvt8sHEPuNyExwwssLAXIDmVHQlGWQ.9kvzJK0Qi'
  use      Rack::Flash,           sweep:  true
  use      Warden::Manager do |manager|
    manager.default_strategies :email_and_password
    manager.failure_app = Application
  end
  use      Rack::Conneg do |conneg|
    conneg.set :accept_all_extensions, false
    conneg.set :fallback, :html
    conneg.ignore_contents_of(File.dirname(__FILE__) + "/../public")
    conneg.provide([:html, :json, :xml, :js])
  end
  register Warden

  helpers do
    include Sinatra::Paginator

    def escape_javascript(js)
      EscapeUtils.escape_javascript(js)
    end

    def escape_html(html)
      EscapeUtils.escape_html(html)
    end

    #partial rendering
    def partial(page, variables = {}, options = {})
      template_type = options.fetch(:in) { :haml }
      send(template_type, page.to_sym, options.merge!(layout: false))
    end

    alias_method :h, :escape_html
    alias_method :j, :escape_javascript
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
    @references = current_user.paginated_references(params[:page])
    respond_to do |format|
      format.json { @references.to_json }
      format.html { haml :user }
    end
  end

  get '/me/new_link' do
    haml :new_link
  end

  post '/me/create_link' do
    begin
      current_user.create_reference(params)
    rescue DuplicateReference
      flash[:notice] = 'Link was already referenced.'
    rescue ReferenceCreationError
      flash[:error] = 'An error ocurred while saving your link. Please try again later.'
    end
    redirect '/me'
  end

  post '/me/delete_link/:id' do
    respond_to do |format|
      @reference = current_user.references.find(params[:id])
      if @reference.delete
        flash_msg = 'Link deleted'
        @references = current_user.paginated_references(params[:page]) #repaginate

        format.js do
          flash.now[:notice] = flash_msg
          erb :user, layout: false
        end
        format.html do
          flash[:notice] = flash_msg
          redirect '/me'
        end
      else
        flash_msg = 'An error ocurred while deleting your link. Please try again later.'

        format.js do
          flash.now[:error] = flash_msg
          erb :delete_error
        end
        format.html do
          flash[:error] = flash_msg
          haml '/me'
        end
      end
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