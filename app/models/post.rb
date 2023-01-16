class Post < ApplicationRecord
  validate :url_must_exist, if: :will_save_change_to_url?
  before_save :create_link_preview, if: :will_save_change_to_url?

  belongs_to :user
  belongs_to :community, optional: true

  has_many :votes, class_name: 'PostVote', dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :saves, class_name: 'PostSave', dependent: :destroy
  belongs_to :link, dependent: :destroy, optional: true

  has_many_attached :media do |attachable|
    attachable.variant :thumb, resize_to_limit: [100, 100]
  end

  validates :title, presence: true, length: { maximum: 100 }
  validates :url, format: { with: URI::DEFAULT_PARSER.make_regexp }, presence: true, if: :link_post?
  validates :body, presence: true, if: :text_post?
  validates :media, presence: true, if: :media_post?

  VALID_STATUSES = %w[public private draft archived].freeze
  VALID_TYPES = %w[text media link].freeze

  validates :status, inclusion: { in: VALID_STATUSES }
  validates :post_type, inclusion: { in: VALID_TYPES }

  # --- scopes ---
  scope :public_posts, -> { where(status: 'public') }

  # -- static methods ---
  def self.update_link_previews
    Post.where(post_type: 'link').each(&:update_link_preview)
  end

  # -- callbacks ---

  def url_must_exist
    return unless link_post?

    begin
      LinkThumbnailer.generate(url)
    rescue LinkThumbnailer::BadUriFormat
      errors.add(:url, 'is not a valid URL')
    rescue OpenSSL::SSL::SSLError
      errors.add(:url, 'is not a valid URL')
    rescue LinkThumbnailer::HTTPError
      errors.add(:url, 'does not exist')
    end
  end

  def create_link_preview(save = false)
    return unless link_post?

    link_obj = Link.find_or_create_by(url: url)
    if save
      update(link: link_obj)
    else
      self.link = link_obj
    end
  end

  def update_link_preview
    return unless link_post?

    link = Link.find_or_create_by(url: url) if link.nil?
    link.create_link_preview
  end

  # --- getters ---
  def title
    if archived?
      'Archived Post'
    else
      read_attribute(:title)
    end
  end

  def body
    if archived?
      'This post has been archived.'
    else
      read_attribute(:body)
    end
  end

  # --- predicates ---
  def public?
    status == 'public'
  end

  def archived?
    status == 'archived'
  end

  def draft?
    status == 'draft'
  end

  def text_post?
    post_type == 'text'
  end

  def media_post?
    post_type == 'media'
  end

  def link_post?
    post_type == 'link'
  end

  # -- instance methods ---
  def vote(user, upvote = true)
    if votes.find_by(user: user, isUpvote: upvote)
      votes.find_by(user: user, isUpvote: upvote).destroy
    elsif (vote = votes.find_by(user: user))
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

  def archive
    update(status: 'archived')
  end

  def publish
    return unless save # check if draft is valid

    update(status: 'public', created_at: Time.now)
  end
end
