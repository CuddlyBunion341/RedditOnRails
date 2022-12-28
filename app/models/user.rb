class User < ApplicationRecord
  has_secure_password

  validates :username, presence: true, uniqueness: true, format: { with: /[a-zA-Z0-9_]{1,20}/, message: "Invalid Username" }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: "Invalid Email" }
  validates :bio, length: { maximum: 200 }

  has_many :posts
  has_many :comments
  has_many :post_votes, dependent: :destroy
  has_many :post_saves, class_name: "PostSave", dependent: :destroy

  has_many :followers, class_name: "Follower", foreign_key: :user_id
  has_many :following, class_name: "Follower", foreign_key: :follower_id

  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_limit: [100, 100]
  end

  def drafts
    posts.where(status: "draft")
  end

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
    following.find_by(user: user)
  end

  def follow(user)
    following.create(user: user)
  end

  def unfollow(user)
    following.find_by(user: user).destroy
  end

  def followed_by?(user)
    followers.find_by(follower: user)
  end
end
