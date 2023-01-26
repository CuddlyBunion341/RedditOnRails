class Post < ApplicationRecord
  include Votable
  include Savable
  include Pinable

  validate :url_must_exist, if: :will_save_change_to_url?
  before_save :create_link_preview, if: :will_save_change_to_url?

  belongs_to :user
  belongs_to :community, optional: true
  belongs_to :link, dependent: :destroy, optional: true

  has_many :votes, class_name: 'PostVote', dependent: :destroy
  has_many :saves, class_name: 'PostSave', dependent: :destroy
  has_many :comments, dependent: :destroy
  belongs_to :pin_owner, class_name: 'User', optional: true

  has_many_attached :media do |attachable|
    attachable.variant :thumb, resize_to_limit: [100, 100]
  end

  validates :title, presence: true, length: { maximum: 100 }
  validates :url, format: URI::DEFAULT_PARSER.make_regexp(%w[http https]), presence: true, if: :type_link?

  validates :body, presence: true, if: :type_text?
  validates :media, presence: true, if: :type_media?

  enum :status, { draft: 0, published: 1, archived: 2 }
  enum :post_type, { text: 0, media: 1, link: 2 }, prefix: 'type'

  # -- static methods ---
  def self.update_link_previews
    Post.where(post_type: 'link').each(&:update_link_preview)
  end

  # -- callbacks ---

  def url_must_exist
    return unless type_link?

    begin
      LinkThumbnailer.generate(url)
    rescue URI::InvalidURIError, LinkThumbnailer::BadUriFormat
      # errors.add(:url, 'is not a valid URL')
    rescue OpenSSL::SSL::SSLError
      errors.add(:url, 'is not a valid URL')
    rescue LinkThumbnailer::HTTPError
      errors.add(:url, 'does not exist')
    end
  end

  def create_link_preview(save = false)
    return unless type_link?

    link_obj = Link.find_or_create_by(url: url)
    if save
      update(link: link_obj)
    else
      self.link = link_obj
    end
  end

  def update_link_preview
    return unless type_link?

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

  def archive
    update(status: 'archived')
  end

  def publish
    return unless save

    update(status: 'published', created_at: Time.now)
  end
end
