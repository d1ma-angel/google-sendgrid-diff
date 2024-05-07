# frozen_string_literal: true

class MissingEmailsService
  def initialize(user_id)
    @user_id = user_id
  end

  def call
    emails = google_emails.difference(sendgrid_emails)
    return if emails.empty?

    content = SendGrid::Content.new(type: 'text/html', value: emails.join('<br />'))
    SendgridEmailSendService.new(@user_id, content).call
  end

  private

  def google_emails
    @google_emails ||= GoogleEmailListingService.new(@user_id).call
  end

  def sendgrid_emails
    @sendgrid_emails ||= SendgridEmailListingService.new(google_emails).call
  end
end
