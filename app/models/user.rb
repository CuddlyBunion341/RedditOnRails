class User < ApplicationRecord
  has_secure_password

  validates :username, presence: true, uniqueness: true,
                       format: { with: /[a-zA-Z0-9_]{1,20}/, message: 'Invalid Username' }
  validates :display_name, presence: true, length: { maximum: 40 }
  validates :email, presence: true, uniqueness: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP, message: 'Invalid Email' }
  validates :bio, length: { maximum: 200 }

  has_many :posts
  has_many :comments
  has_many :post_votes, dependent: :destroy
  has_many :comment_votes, dependent: :destroy
  has_many :post_saves, class_name: 'PostSave', dependent: :destroy

  has_many :followers, class_name: 'Follower', foreign_key: :user_id
  has_many :following, class_name: 'Follower', foreign_key: :follower_id
  has_many :joined_communities, class_name: 'CommunityMember', foreign_key: :user_id
  has_many :pinned_posts, class_name: 'Post', foreign_key: :pin_owner_id

  has_many :owned_communities, class_name: 'Community', foreign_key: :owner_id

  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_limit: [100, 100]
  end

  before_create do
    self.display_name = username
  end

  def self.search(query)
    where('username LIKE ? OR display_name LIKE ?', "%#{query}%", "%#{query}%")
  end

  def login
    update(last_online: Time.now, is_online: true)
  end

  def logout
    update(last_online: Time.now, is_online: false)
  end

  def drafts
    posts.where(status: 'draft')
  end

  def editable?
    Current.user == self
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

  def upvoted_comment?(comment)
    comment_votes.find_by(comment: comment, isUpvote: true)
  end

  def downvoted_comment?(comment)
    comment_votes.find_by(comment: comment, isUpvote: false)
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
