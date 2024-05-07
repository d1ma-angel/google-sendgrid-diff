# frozen_string_literal: true

class GoogleAuthService
  def initialize(user_id)
    @user_id = user_id
  end

  def credentials
    return @credentials if defined? @credentials

    @credentials = authorizer.get_credentials(@user_id)
  end

  def authorizer
    return @authorizer if defined? @authorizer

    client_id = Google::Auth::ClientId.from_file('config/google-credentials.json')
    token_store = Google::Auth::Stores::RedisTokenStore.new(redis: Config.redis)
    @authorizer = Google::Auth::WebUserAuthorizer.new(client_id, scope, token_store, '/oauth2callback')
  end

  def scope
    Google::Apis::GmailV1::AUTH_GMAIL_READONLY
  end
end
