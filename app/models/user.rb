class User < ActiveRecord::Base
  validates :name, presence: true, length: { minimum: 3, maximum: 50 }
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z])*\.[a-z]+\z/i
  validates :email, presence: true, format: { with: EMAIL_REGEX },
            uniqueness: { case_sensitive: false }

  has_secure_password

  validates :password, length: { minimum: 6 }

  before_save :downcase_email!

  private

  def downcase_email!
    email.downcase!
  end
end
