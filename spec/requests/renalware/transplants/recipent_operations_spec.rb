describe "Transplant Recipient Operation" do
  let(:patient) { create(:transplant_patient, family_name: "Rabbit", local_patient_id: "12345") }

  describe "GET show" do
    it "responds successfully" do
      operation = create(:transplant_recipient_operation, patient:)

      get patient_transplants_recipient_operation_path(patient, operation)

      expect(response).to be_successful
    end
  end

  describe "GET edit" do
    it "loads UKT death cause labels and values from the database" do
      create(:transplant_ukt_death_cause, code: "brain_tumour", name: "Brain tumour")
      operation = create(:transplant_recipient_operation, patient:)

      get edit_patient_transplants_recipient_operation_path(patient, operation)

      select = response.parsed_body.at_css("select[name$='[ukt_cause_of_death]']")
      option = select.at_xpath("./option[@value='brain_tumour']")

      expect(option.text).to eq("Brain tumour")
    end
  end
end
