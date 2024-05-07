# frozen_string_literal: true

module Config
  extend self

  def environment
    config.dig('sinatra', 'environment')
  end

  def session_secret
    config.dig('sinatra', 'session_secret')
  end

  def redis_host
    config.dig('redis', 'host')
  end

  def redis_port
    config.dig('redis', 'port')
  end

  def redis_db
    config.dig('redis', 'db')
  end

  def redis_url
    "redis://#{redis_host}:#{redis_port}/#{redis_db}"
  end

  def sendgrid_api_key
    config.dig('sendgrid', 'key')
  end

  def sendgrid_from
    config.dig('sendgrid', 'from')
  end

  def sendgrid_name
    config.dig('sendgrid', 'name')
  end

  def days_qty
    config['days_qty'].to_i
  end

  private

  def config
    @config ||= YAML.load_file('config/config.yaml')
  end
end
