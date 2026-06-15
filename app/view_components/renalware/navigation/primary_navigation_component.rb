module Renalware
  module Navigation
    class PrimaryNavigationComponent < ApplicationComponent
      include Renalware::UsersHelper

      rattr_initialize [:the_patient_search]

      delegate :label_tag, :main_app, :search_form_for, :semantic_app_version, to: :helpers

      def signed_in? = current_user.present?

      def menu_groups
        @menu_groups ||= MenuGroups.new(component: self).to_a
      end

      def primary_menu_groups
        menu_groups.reject { |group| group[:id] == "help" }
      end

      def help_menu_group
        menu_groups.find { |group| group[:id] == "help" }
      end

      def unread_message_count_component
        Renalware::Messaging::UnreadMessageCountComponent.new(current_user:)
      end

      def current_user_menu_label
        current_user.username.to_s.capitalize
      end

      def external_link_options(path)
        return {} unless path.to_s.start_with?("http")

        { rel: "noopener external", target: "_blank" }
      end

      def inline_icon(...)
        helpers.inline_icon(...)
      end

      def authoring
        Renalware::Authoring::Engine.routes.url_helpers
      end

      def directory
        Renalware::Directory::Engine.routes.url_helpers
      end

      def reporting
        Renalware::Reporting::Engine.routes.url_helpers
      end

      def research
        Renalware::Research::Engine.routes.url_helpers
      end
    end
  end
end
