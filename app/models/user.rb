class User < ActiveRecord::Base
  include Deviseable
  include Permissible

  validates_uniqueness_of :username
  validates_presence_of :first_name
  validates_presence_of :last_name
  validate :approval_with_roles

  def full_name
    "#{first_name} #{last_name}"
  end

  # @section services
  #
  def approve
    self.approved = true
  end

  def authorise!(roles, approved)
    transaction do
      self.approve if approved
      self.roles = roles
      self.save!
    end
  rescue ActiveRecord::RecordInvalid
    false
  end

  # @section custom validation methods
  #
  def approval_with_roles
    if self.approved? && self.roles.empty?
      errors.add(:approved, "approved users must have a role")
    end
  end
end
