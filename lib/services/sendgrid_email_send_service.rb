# frozen_string_literal: true

class SendgridEmailSendService
  def initialize(user_id, content)
    @user_id = user_id
    @content = content
  end

  def call
    mail = SendGrid::Mail.new(
      SendGrid::Email.new(email: Config.sendgrid_from, name: Config.sendgrid_name),
      'The missing emails are:',
      SendGrid::Email.new(email: user.email, name: user.username),
      @content
    )

    sendgrid.client.mail._('send').post(request_body: mail.to_json)
  end

  private

  def user
    @user ||= User.find(@user_id)
  end

  def sendgrid
    @sendgrid ||= SendGrid::API.new(api_key: Config.sendgrid_api_key)
  end
end
