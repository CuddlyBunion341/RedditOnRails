class Comment < ApplicationRecord
  include Votable
  include Savable

  belongs_to :user
  belongs_to :post

  has_many :votes, class_name: 'CommentVote', dependent: :destroy
  has_many :saves, class_name: 'CommentSave', dependent: :destroy

  validates :body, presence: true
end
