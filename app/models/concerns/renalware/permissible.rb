require 'active_support/concern'

module Renalware
  module Permissible
    extend ActiveSupport::Concern

    included do
      class_eval do
        has_and_belongs_to_many :roles

        Permission.all.map(&:role).uniq.each do |role_name|
          define_method(:"#{role_name}?") { has_role?(role_name.to_sym) }
        end
      end

      def has_role?(name)
        !!roles.find_by(name: name)
      end

      def role_names
        roles.map { |r| r.name.humanize }
      end
    end
  end
end