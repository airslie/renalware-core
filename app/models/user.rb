class User < ActiveRecord::Base
  include Deviseable
  include Permissible

  validates :username, presence: true, uniqueness: true
  validates_presence_of :first_name
  validates_presence_of :last_name
  validate :approval_with_roles

  scope :unapproved, -> { where(approved: [nil, false]) }

  def full_name
    "#{first_name} #{last_name}"
  end

  def last_first
    "#{last_name}, #{first_name}"
  end

  def read_only?
    has_role?(:read_only)
  end

  # @section services
  #
  def approve
    self.approved = true
  end

  def authorise!(roles, approved)
    notify = !self.approved
    transaction do
      self.approve if approved
      self.roles = roles
      self.save!
    end

    # TODO This should use ActiveJob's deliver_later method in a background process.
    # Currently not using a worker process because Heroku.
    Admin::UserMailer.approval(self).deliver_now if notify
    true

  rescue ActiveRecord::RecordInvalid
    false
  end

  # @section custom validation methods
  #
  def approval_with_roles
    if self.approved? && self.roles.empty?
      errors.add(:approved, 'approved users must have a role')
    end
  end
end
