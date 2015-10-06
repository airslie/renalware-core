require 'pundit'

module Pundit
  # To reduce the explosion of policy classes for each model we use a default
  # base policy that can be configured using a permission file (e.g. config/permissions.yml).
  #
  # This base policy class is only used if no other policy class is found for the record.
  #
  def self.policy!(user, record)
    policy_class = PolicyFinder.new(record).policy || Renalware::BasePolicy
    policy_class.new(user, record)
  end
end
