# frozen_string_literal: true

require_relative "../page_object"

module Pages
  module Clinical
    class ProfilePage < Pages::PageObject
      pattr_initialize :patient

      def edit
        visit patient_clinical_profile_path(patient)
        within ".page-actions" do
          click_on t("btn.edit")
        end
      end

      def save
        within ".form-actions" do
          find("input[name='commit']").click
        end
      end

      def named_consultant=(user)
        select user.to_s, from: "Named consultant"
      end
    end
  end
end
