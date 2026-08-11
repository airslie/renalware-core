FactoryBot.define do
  factory :transplant_nhsbt_wait_list_upload,
          class: "Renalware::Transplants::NHSBTWaitListUpload" do
    accountable
    filename { "nhsbt_wait_list.csv" }
    status { :previewing }
    matched_count { 0 }
    unmatched_count { 0 }
    imported_count { 0 }
    rows { [] }
  end
end
