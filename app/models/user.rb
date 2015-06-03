class User < ActiveRecord::Base
  include Deviseable
  include Permissible

  validates :username, presence: true, uniqueness: true
  validates_presence_of :first_name
  validates_presence_of :last_name
  validate :approval_with_roles, on: :update

  scope :unapproved, -> { where(approved: [nil, false]) }
  scope :expired, -> { where.not(expired_at: nil) }

  def full_name
    "#{first_name} #{last_name}"
  end

  def last_first
    "#{last_name}, #{first_name}"
  end

  def read_only?
    has_role?(:read_only)
  end

  # @section custom validation methods
  #
  def approval_with_roles
    if self.approved? && self.roles.empty?
      errors.add(:approved, 'approved users must have a role')
    end
  end
end
