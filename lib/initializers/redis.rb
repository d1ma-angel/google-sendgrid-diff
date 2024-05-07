# frozen_string_literal: true

module Config
  def self.redis
    @redis ||= ConnectionPool::Wrapper.new do
      Redis.new(url: Config.redis_url)
    end
  end
end
