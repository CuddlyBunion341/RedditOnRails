class Comment < ApplicationRecord
  include Votable

  belongs_to :user
  belongs_to :post
  has_many :votes, class_name: 'CommentVote', dependent: :destroy

  validates :body, presence: true
end
