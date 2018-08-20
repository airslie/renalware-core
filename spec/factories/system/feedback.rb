# frozen_string_literal: true

FactoryBot.define do
  factory :user_feedback, class: "Renalware::System::UserFeedback" do
    association :author, factory: :user
    comment { "My feedback is.." }
    admin_notes { "" }
    category { :general_comment }
  end
end
