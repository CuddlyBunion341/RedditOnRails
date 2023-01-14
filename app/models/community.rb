class Community < ApplicationRecord
  belongs_to :owner, class_name: "User"

  has_many :posts, dependent: :destroy

  validates :name, presence: true, length: { in: 3..40 }
  validates :shortname, presence: true, length: { in: 3..20 }, format: { with: /\w+/ }

  def active_users
    User.joins(:posts).where(posts: { community_id: id }).group(:id).order("count(posts.id) desc").limit(10)
  end
end
