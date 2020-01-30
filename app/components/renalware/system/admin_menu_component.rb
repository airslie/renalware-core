# frozen_string_literal: true

module Renalware
  module System
    # Experimental ActionView component
    class AdminMenuComponent < ApplicationComponent
      include Renalware::UsersHelper
      attr_reader :current_user

      def initialize(current_user:)
        @current_user = current_user
      end

      def admin_menu_item(*args)
        return unless
          current_user_is_admin? ||
          current_user_is_super_admin? ||
          current_user_is_developer?

        menu_item(*args)
      end

      def super_admin_menu_item(*args)
        return unless current_user_is_super_admin? || current_user_is_developer?

        menu_item(*args)
      end

      def developer_menu_item(*args)
        return unless current_user_is_developer?

        menu_item(*args)
      end

      def menu_item(title, path, active_when_controller_matches, enabled = true)
        klasses = %w(link)
        klasses << "active" if current_controller_matches(active_when_controller_matches)
        content_tag :li, class: klasses.join(" ") do
          if enabled
            link_to(title, path)
          else
            content_tag :span, title
          end
        end
      end

      def current_controller_matches(regex)
        regex.match(params[:controller]).present?
      end

      def formatted_nhs_number(patient)
        ::Renalware::PatientPresenter.new(patient).nhs_number
      end
    end
  end
end
