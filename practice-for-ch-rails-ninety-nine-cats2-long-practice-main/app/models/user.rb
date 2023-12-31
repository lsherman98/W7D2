class User < ApplicationRecord

  validates :username, :session_token, presence: true, uniqueness: true
  validates :password_digest, presence: true
  validates :password, length: { minimum: 6 }, allow_nil: true

  before_validation :ensure_session_token
  attr_reader :password

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    password_obj = BCrypt::Password.new(self.password_digest)
    password_obj.is_password?(password)
  end

  def self.find_by_credentials(username, password)
    @user = User.find_by(username: username)

    if @user && is_password?(password)
      #login!
      @user
    else
      nil
    end
  end

  def reset_session_token!
    self.session_token = generate_unique_session_token
    self.save!
    self.session_token
  end



  private
  def generate_unique_session_token
    SecureRandom::urlsafe_base64
  end

  def ensure_session_token
    self.session_token ||= generate_unique_session_token
  end

end
