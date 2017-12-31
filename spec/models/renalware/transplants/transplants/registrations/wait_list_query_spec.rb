require "rails_helper"

module Renalware
  module Transplants
    module Registrations
      describe WaitListQuery, type: :model do
        describe "#call" do
          subject(:query) { WaitListQuery.new(quick_filter: filter) }

          before do
            create(:transplant_registration, :in_status, status: "active")
            create(:transplant_registration, :in_status, status: "suspended")
            create(:transplant_registration, :in_status, status: "working_up")
            create(:transplant_registration, :in_status, status: "working_up_lrf")
          end

          context "with filter 'active'" do
            let(:filter) { :active }

            it "returns the active registrations" do
              expect(query.call.count).to eq(1)
            end
          end

          context "with filter 'suspended'" do
            let(:filter) { :suspended }

            it "returns the suspended registrations" do
              expect(query.call.count).to eq(1)
            end
          end

          context "with filter 'active_and_suspended'" do
            let(:filter) { :active_and_suspended }

            it "returns the active and suspended registrations" do
              expect(query.call.count).to eq(2)
            end
          end

          context "with filter 'working_up'" do
            let(:filter) { :working_up }

            it "returns the working-up registrations" do
              expect(query.call.count).to eq(2)
            end
          end
        end
      end
    end
  end
end
