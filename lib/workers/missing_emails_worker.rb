# frozen_string_literal: true

class MissingEmailsWorker
  include Sidekiq::Worker

  def perform(user_id)
    MissingEmailsService.new(user_id).call
  end
end
