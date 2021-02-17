# frozen_string_literal: true

require "rails_helper"
require_relative "../page_object"
require "capybara-select-2"
module Pages
  module Letters
    class Form < PageObject
      include CapybaraSelect2

      PERSON_ROLE_TO_RADIO_ID_MAP = {
        patient: :letter_main_recipient_attributes_person_role_patient,
        primary_care_physician:
          :letter_main_recipient_attributes_person_role_primary_care_physician,
        gp: :letter_main_recipient_attributes_person_role_primary_care_physician,
        contact: :letter_main_recipient_attributes_person_role_contact
      }.freeze

      def issued_on=(date)
        fill_in "Date", with: l(date)
      end

      def letterhead=(letterhead)
        select letterhead, from: "Letterhead"
      end

      def author=(user)
        select user.to_s, from: "Author"
      end

      def description=(value)
        select2 value, css: ".letter_description"
      end

      def main_recipient=(main_recipient_role)
        within ".letter_main_recipient_person_role" do
          radio_id = map_main_recipient_to_radio_id(main_recipient_role)
          choose(radio_id)
        end
      end

      # If using :contact as main_recipient then we need to select which recipient to use
      # from the contacts dropdown
      def main_recipient_contact_name=(name)
        select name, from: "letter_main_recipient_attributes_addressee_id"
      end

      def submit
        within ".top" do
          click_on t("btn.create")
        end
      end

      private

      def map_main_recipient_to_radio_id(main_recipient_type)
        PERSON_ROLE_TO_RADIO_ID_MAP.fetch(
          main_recipient_type.to_s.downcase.to_sym
        )
      end
    end
  end
end
