class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: :follower_id, dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, class_name: 'Relationship',
                                   foreign_key: :followed_id,
                                   dependent: :destroy
  has_many :followers, through: :reverse_relationships, source: :follower

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

  def feed
    Micropost.from_users_followed_by(self)
  end

  def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy!
  end

  private

  def downcase_email!
    email.downcase!
  end

  def create_remember_token
    self.remember_token = User.encrypt(User.new_remember_token)
  end
end
