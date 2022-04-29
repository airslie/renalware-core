# frozen_string_literal: true

module Renalware
  module Patients
    # Queries for and stores in a class variable the list of MDM 'scopes' to use when building
    # the MDM menu. An example of a scope is "transplant" or "low_clearance".
    # If you make changes to the system_view_metadata table to add/edit/remove a scope,
    # you will need to restart the app for changes to to reflect in the menu. It is done this
    # way as a changes are rare and we want to avoid running this query too many times.
    # I think it will run once per procethread
    class MDMMenu
      thread_cattr_accessor :cached_items

      def self.items
        return cached_items if cached_items

        self.cached_items = array_of_distinct_scopes_for_all_mdm_list_views
        cached_items
      end

      def self.array_of_distinct_scopes_for_all_mdm_list_views
        Rails.logger.info "#### Loading MDM scope names! ####"
        scopes = Renalware::System::ViewMetadata
          .distinct("scope")
          .where(category: :mdm)
          .pluck(:scope)

        remove_invalid_scope_names_that_could_break_menu_rendering(scopes)
      end

      # Only accept MDM scopes names that are simple lower case underscored
      # strings eg "my_view_name".
      def self.remove_invalid_scope_names_that_could_break_menu_rendering(scopes)
        scopes.grep(/^[a-z0-9_]*$/)
      end

      private_class_method :array_of_distinct_scopes_for_all_mdm_list_views
      private_class_method :cached_items
    end
  end
end
