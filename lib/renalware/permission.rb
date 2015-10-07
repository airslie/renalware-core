module Renalware
  class Permission < Struct.new(:role, :ability, :models)

    def self.all
      [ Permission.new(:super_admin, :manage, :all),
        Permission.new(:admin, :manage, admin_models),
        Permission.new(:clinician, :manage, clinical_models),
        Permission.new(:clinician, :read, admin_models),
        Permission.new(:read_only, :read, :all) ]
    end

    private

    def self.admin_models
      admin_only_models + clinical_models
    end

    def self.admin_only_models
      config[:admin].map(&:safe_constantize)
    end

    def self.clinical_models
      super_admin_models = config[:super_admin].map(&:safe_constantize)
      renalware_models - (super_admin_models + admin_only_models)
    end

    def self.renalware_models
      @models = ActiveRecord::Base.descendants
    end

    def self.config
      @permissions ||= YAML.load_file(Rails.root.join('config', 'permissions.yml')).symbolize_keys
    end
  end
end