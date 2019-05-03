# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  name            :string           not null
#  session_token   :string
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
  validates :name, :session_token, presence: true, uniqueness: true
  validates :password_digest, presence: true
  validates :password, length: { minimum: 6, allow_nil: true }

  after_initialize :ensure_session_token
  attr_reader :password

  def self.find_by_credentials(name, password)
    user = User.find_by(name: name)
    return nil unless user && user.is_password?(password)
    user
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    bcrypt = BCrypt::Password.new(self.password_digest)
    bcrypt.is_password?(password)
  end

  def reset_session_token!
    self.update!(session_token: self.class.generate_session_token)
    self.session_token
  end

  private
  def ensure_session_token
    self.session_token ||= self.class.generate_session_token
  end

  def self.generate_session_token
    SecureRandom::urlsafe_base64
  end
end
