class Comment < ApplicationRecord
  include Votable
  include Savable

  belongs_to :user
  belongs_to :post
  belongs_to :parent, class_name: 'Comment', optional: true

  has_many :votes, class_name: 'CommentVote', dependent: :destroy
  has_many :saves, class_name: 'CommentSave', dependent: :destroy
  has_many :children, class_name: 'Comment', foreign_key: 'parent_id', dependent: :destroy

  validates :body, presence: true

  def self.search(query)
    where('body LIKE ?', "%#{query}%")
  end

  def indentations
    parent ? parent.indentations + 1 : 0
  end
end
