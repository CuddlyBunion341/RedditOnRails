class CommunityMember < ApplicationRecord
  belongs_to :user
  belongs_to :community

  enum role: { member: 0, moderator: 1 }
end
