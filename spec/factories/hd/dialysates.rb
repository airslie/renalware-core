FactoryGirl.define do
  factory :hd_dialysate, class: "Renalware::HD::Dialysate" do
    name "Fresenius A7"
    sodium_content 4
    sodium_content_uom "mmol/L"
    description nil
    deleted_at nil
  end
end
