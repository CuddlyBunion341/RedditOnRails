class Post < ApplicationRecord
  belongs_to :user

  has_many :votes, class_name: "PostVote", dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true

  VALID_STATUSES = %w[public private draft archived].freeze

  validates :status, inclusion: { in: VALID_STATUSES }

  # --- getters ---
  def title
    if archived?
      "Archived Post"
    else
      read_attribute(:title)
    end
  end

  def body
    if archived?
      "This post has been archived."
    else
      read_attribute(:body)
    end
  end

  # --- predicates ---
  def public?
    status == "public"
  end

  def archived?
    status == "archived"
  end

  # -- helpers ---
  def vote(user, upvote = true)
    if votes.find_by(user: user, isUpvote: upvote)
      votes.find_by(user: user, isUpvote: upvote).destroy
    elsif vote = votes.find_by(user: user)
      vote.update(isUpvote: upvote)
    else
      votes.create(user: user, isUpvote: upvote)
    end

    votes.where(isUpvote: true).count - votes.where(isUpvote: false).count
  end

  def upvote(user)
    vote(user, true)
  end

  def downvote(user)
    vote(user, false)
  end

  def bookmark(user)
    if user.saved?(self)
      user.post_saves.find_by(post: self).destroy
    else
      user.post_saves.create(post: self)
    end
  end
end
