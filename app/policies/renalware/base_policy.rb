module Renalware
  # Responsible for determining if a user can manage the provided record. It
  # provides the Base policy for Renalware.
  #
  # It collaborates with a permission configuration object to determine
  # if the record is is an instance of a model that is #restricted? and
  # if the user #has_permission? to manage the record.
  #
  class BasePolicy < ApplicationPolicy
    def initialize(user, record, permission_configuration=nil)
      super(user, record)

      @permission_configuration = permission_configuration || default_permission_configuration
    end

    def index?
      case
      when user.super_admin?
        true
      when restricted?
        has_permission_for_restricted?
      else
        has_any_role?
      end
    end

    def show?
      has_any_role?
    end

    def create?
      case
      when user.super_admin?
        true
      when restricted?
        has_permission_for_restricted?
      else
        has_write_privileges?
      end
    end

    def update?
      create?
    end

    def destroy?
      create?
    end

    private

    attr_reader :permission_configuration

    def restricted?
      permission_configuration.restricted?
    end

    def has_permission_for_restricted?
      permission_configuration.has_permission?(user)
    end

    def has_write_privileges?
      user.super_admin? || user.admin? || user.clinician?
    end

    def has_any_role?
      user.roles.any?
    end

    def default_permission_configuration
      YAMLPermissionConfiguration.new(record.class)
    end
  end
end
