# frozen_string_literal: true

class App < Sinatra::Base
  set :environment, Config.environment

  enable :sessions
  set :session_secret, Config.session_secret

  get '/' do
    authorize!
    fetch_alerts

    erb :home
  end

  get '/emails' do
    authorize!

    google_authorizer = google_auth_service.authorizer
    google_credentials = google_authorizer.get_credentials(current_user.id, request, google_auth_service.scope)
    redirect google_authorizer.get_authorization_url(user_id: current_user.id, request:) if google_credentials.nil?

    fetch_alerts

    erb :emails
  end

  post '/emails' do
    authorize!

    google_authorizer = google_auth_service.authorizer
    google_credentials = google_authorizer.get_credentials(current_user.id, request, google_auth_service.scope)
    redirect '/emails' if google_credentials.nil?

    MissingEmailsWorker.perform_async(current_user.id)

    session[:notice] = 'The emails are being processed. Check your mailbox in a few minutes.'
    redirect '/'
  end

  get '/login' do
    fetch_alerts

    erb :login
  end

  post '/login' do
    user = User.find_by_username(params[:username])
    if user&.authenticate(params[:password])
      session.clear
      session[:user_id] = user.id
      session[:notice] = 'You have been logged on successfully'
      redirect '/'
    else
      session[:error] = 'Username or password was incorrect'
      redirect '/login'
    end
  end

  post '/logout' do
    session.clear

    session[:notice] = 'You have been logged out'
    redirect '/login'
  end

  get '/oauth2callback' do
    Google::Auth::WebUserAuthorizer::CallbackApp.call(env)
  end

  helpers do
    def current_user
      User.find(session[:user_id].to_s) if session[:user_id]
    end
  end

  private

  def authorize!
    redirect '/login' unless current_user
  end

  def fetch_alerts
    @error = session.delete(:error)
    @notice = session.delete(:notice)
  end

  def google_auth_service
    @google_auth_service ||= GoogleAuthService.new(current_user.id)
  end
end
