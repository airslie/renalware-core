# frozen_string_literal: true

FactoryBot.define do
  factory :letter_archive, class: "Renalware::Letters::Archive" do
    content {
      <<-HTML
        <div id="main">
          <div id="toc-distribution-list"/>
          <div id="toc-problem-list"/>
          <div id="toc-medications-and-medical_devices"/>
          <div id="toc-investigation-results"/>
          <div id="toc-author"/>
          <div id="other"/>
        </div>
      HTML
    }
  end
end
