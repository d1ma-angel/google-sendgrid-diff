# frozen_string_literal: true

class User
  attr_reader :id, :username, :email

  def self.all
    @all ||= YAML.load_file('config/config.yaml')['users'].map do |user|
      new(user['id'].to_s, user['username'], user['email'], user['password'])
    end
  end

  def self.find(id)
    all.find { |user| user.id == id }
  end

  def self.find_by_username(username)
    all.find { |user| user.username == username }
  end

  def initialize(id, username, email, password)
    @id = id
    @username = username
    @email = email
    @hash_password = hash_password(password)
  end

  def authenticate(password)
    BCrypt::Password.new(@hash_password) == password
  end

  private

  def hash_password(password)
    BCrypt::Password.create(password).to_s
  end
end
