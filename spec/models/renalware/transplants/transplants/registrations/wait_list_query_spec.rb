require "rails_helper"

module Renalware
  module Transplants
    module Registrations
      describe WaitListQuery, type: :model do
        describe "#call" do
          subject { WaitListQuery.new(quick_filter: filter) }

          before do
            create(:transplant_registration, :in_status, status: "active")
            create(:transplant_registration, :in_status, status: "suspended")
            create(:transplant_registration, :in_status, status: "working_up")
            create(:transplant_registration, :in_status, status: "working_up_lrf")
          end

          context "with filter 'active'" do
            let(:filter) { :active }

            it "returns the active registrations" do
              expect(subject.call.count).to eq(1)
            end
          end

          context "with filter 'suspended'" do
            let(:filter) { :suspended }

            it "returns the suspended registrations" do
              expect(subject.call.count).to eq(1)
            end
          end

          context "with filter 'active_and_suspended'" do
            let(:filter) { :active_and_suspended }

            it "returns the active and suspended registrations" do
              expect(subject.call.count).to eq(2)
            end
          end

          context "with filter 'working_up'" do
            let(:filter) { :working_up }

            it "returns the working-up registrations" do
              expect(subject.call.count).to eq(2)
            end
          end

          context "with filter 'nhb_consent'" do
            let(:filter) { :nhb_consent }

            before do
              reg = Renalware::Transplants::Registration.first!
              reg.document.nhb_consent.value = :yes
              reg.document.nhb_consent.consented_on = Time.zone.today
              reg.document.nhb_consent.full_name = "Someone"
              reg.save!
            end

            it "returns the registrations with nhb consent set to yes" do
              expect(subject.call.count).to eq(1)
            end
          end
        end
      end
    end
  end
end
