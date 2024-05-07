# frozen_string_literal: true

class GoogleEmailListingService
  def initialize(user_id)
    @user_id = user_id
    @google_emails = Set.new
  end

  # rubocop:disable Metrics/MethodLength
  def call
    next_page = nil
    listing_finished = false

    loop do
      list_result = gmail_service.list_user_messages('me', max_results: 100, page_token: next_page)
      list_result.messages.each do |message|
        message_result = gmail_service.get_user_message('me', message.id)
        listing_finished = google_listing_finished?(message_result)
        break if listing_finished

        add_google_email(message_result)
      end
      break if listing_finished

      next_page = list_result.next_page_token
      break unless next_page
    end

    @google_emails
  end
  # rubocop:enable Metrics/MethodLength

  private

  def google_listing_finished?(body)
    datetime_header = body.payload.headers.find { |header| header.name == 'Date' }
    return false unless datetime_header

    Time.parse(datetime_header.value) < (Date.today - Config.days_qty).to_time
  end

  def add_google_email(body)
    body.payload.headers.each do |header|
      next unless header.name == 'From'

      matched = /<([\w\.-]+@[\w\.-]+)>/i.match(header.value)
      matched ||= /([\w\.-]+@[\w\.-]+)/i.match(header.value)
      @google_emails.add(matched[1].downcase) if matched
    end
  end

  def gmail_service
    return @gmail_service if @gmail_service

    @gmail_service = Google::Apis::GmailV1::GmailService.new
    @gmail_service.authorization = google_auth_service.credentials

    @gmail_service
  end

  def google_auth_service
    @google_auth_service ||= GoogleAuthService.new(@user_id)
  end
end
