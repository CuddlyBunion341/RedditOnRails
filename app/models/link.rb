class Link < ApplicationRecord
  after_create :create_link_preview
  has_many :posts

  validates :url, presence: true, uniqueness: true, format: { with: URI.regexp }

  def create_link_preview
    obj = LinkThumbnailer.generate(url)
    update(
      title: obj.title,
      description: obj.description,
      favicon_src: obj.favicon,
      thumb_src: obj.images.first.src,
    )
  end
end
