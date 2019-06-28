class User < ActiveRecord::Base
  validates :name, presence: true, length: { minimum: 3, maximum: 50 }
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z])*\.[a-z]+\z/i
  validates :email, presence: true, format: { with: EMAIL_REGEX },
            uniqueness: { case_sensitive: false }

  has_secure_password

  validates :password, length: { minimum: 6 }

  before_save :downcase_email!
  before_create :create_remember_token

  class << self
    def encrypt(token)
      Digest::SHA1.hexdigest(token.to_s)
    end

    def new_remember_token
      SecureRandom.urlsafe_base64
    end
  end

  private

  def downcase_email!
    email.downcase!
  end

  def create_remember_token
    self.remember_token = User.encrypt(User.new_remember_token)
  end
end
