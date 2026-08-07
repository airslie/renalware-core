module Renalware::Messaging::Internal
  describe Recipient do
    it :aggregate_failures do
      is_expected.to have_many(:messages).through(:receipts)
      is_expected.to have_many(:receipts).class_name("Renalware::Messaging::Internal::Receipt")
    end

    describe "#activity_warning" do
      it "warns when the recipient has never signed in" do
        recipient = build(
          :internal_recipient,
          last_sign_in_at: nil,
          current_sign_in_at: nil
        )

        expect(recipient.activity_warning).to eq("(has never signed in)")
      end

      it "does not warn when the recipient has signed in recently" do
        recipient = build(
          :internal_recipient,
          last_sign_in_at: 3.months.ago,
          current_sign_in_at: 1.day.ago
        )

        expect(recipient.activity_warning).to be_nil
      end

      it "warns when the recipient has not signed in recently" do
        signed_in_at = 10.days.ago
        recipient = build(
          :internal_recipient,
          last_sign_in_at: 30.days.ago,
          current_sign_in_at: signed_in_at
        )

        days_since_sign_in = (Time.zone.today - signed_in_at.to_date).to_i
        expect(recipient.activity_warning).to eq("(inactive for #{days_since_sign_in} days)")
      end
    end
  end
end
