class Community < ApplicationRecord
  belongs_to :owner, class_name: "User"

  has_many :posts, dependent: :destroy
end
