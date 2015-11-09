require_dependency "renalware"

module Renalware
  module Blameable
    extend ActiveSupport::Concern

    included do
      belongs_to :created_by, class_name: "Renalware::User"
      belongs_to :updated_by, class_name: "Renalware::User"

      before_create :assign_creator
      before_update :assign_updater

      attr_accessor :by
    end

    private

    def assign_creator
      self.created_by ||= by
      self.updated_by = created_by
    end

    def assign_updater
      return unless persisted?
      return if updated_by_id_changed?

      self.updated_by = by
    end
  end
end
