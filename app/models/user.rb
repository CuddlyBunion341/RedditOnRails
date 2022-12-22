class User < ApplicationRecord
  has_secure_password

  validates :username, presence: true, uniqueness: true, format: { with: /[a-zA-Z0-9_]{1,20}/, message: "Invalid Username" }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: "Invalid Email" }

  has_many :posts
  has_many :comments
  has_many :post_votes, dependent: :destroy
  has_many :post_saves, class_name: "PostSave", dependent: :destroy
  has_many :followers, class_name: "Follower", foreign_key: "user_id", dependent: :destroy
  has_many :following, class_name: "Follower", foreign_key: "follower_id", dependent: :destroy

  def saved_posts
    Post.where(id: post_saves.pluck(:post_id))
  end

  def saved?(post)
    post_saves.find_by(post: post)
  end

  def upvoted?(post)
    post_votes.find_by(post: post, isUpvote: true)
  end

  def downvoted?(post)
    post_votes.find_by(post: post, isUpvote: false)
  end

  def following?(user)
    followers.find_by(user: user)
  end

  def followed_by?(user)
    user.followers.find_by(user: self)
  end

  def follow(user)
    if followers.find_by(user: user).nil?
      followers.create(user: user)
    else
      followers.find_by(user: user).destroy
    end
  end
end
