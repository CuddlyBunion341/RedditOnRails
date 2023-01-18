module Savable
  extend ActiveSupport::Concern

  def bookmark(user)
    if saves.find_by(user: user)
      saves.find_by(user: user).destroy
    else
      saves.create(user: user)
    end
  end

  def saved_by?(user)
    saves.find_by(user: user).present?
  end
end
