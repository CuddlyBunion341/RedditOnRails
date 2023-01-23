module Pinable
  extend ActiveSupport::Concern

  def pin(user)
    if pin_owner
      update(pin_owner: nil)
    else
      update(pin_owner: user)
    end
  end

  def pinned_by?(user)
    pin_owner == user
  end

  def pinned?
    pin_owner.present?
  end
end
