class Post < ApplicationRecord
  belongs_to :user

  has_many :votes, class_name: "PostVote", dependent: :destroy

  validates :title, presence: true
end
