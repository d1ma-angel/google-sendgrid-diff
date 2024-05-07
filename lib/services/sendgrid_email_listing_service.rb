# frozen_string_literal: true

class SendgridEmailListingService
  def initialize(google_emails)
    @google_emails = google_emails
    @sendgrid_emails = Set.new
  end

  def call
    return @sendgrid_emails if @sendgrid_emails

    @sendgrid_emails = Set.new
    sendgrid_conditions.each do |conditions|
      response = sendgrid.client.contactdb.recipients.search.post(request_body: { conditions: })
      next unless response.status_code.to_i == 200

      add_sendgrid_email(response.body)
    end

    @sendgrid_emails
  end

  private

  attr_reader :google_emails

  def sendgrid_conditions
    google_emails.each_slice(15).to_a.map do |emails|
      emails.each_with_index.map do |email, index|
        {
          and_or: index.zero? ? '' : 'or',
          field: 'email',
          value: email,
          operator: 'eq'
        }
      end
    end
  end

  def add_sendgrid_email(body)
    JSON.parse(body)['recipients'].each do |recipient|
      @sendgrid_emails.add(recipient['email'].downcase) if recipient['email']
    end
  end

  def sendgrid
    @sendgrid ||= SendGrid::API.new(api_key: Config.sendgrid_api_key)
  end
end
