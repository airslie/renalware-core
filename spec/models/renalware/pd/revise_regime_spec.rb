require "rails_helper"

module Renalware
  module PD
    RSpec.describe ReviseRegime do
      let(:patient) { create(:patient) }
      let(:regime) do
        regime = build(:apd_regime, add_hd: false)
        regime.bags << build(:pd_regime_bag, sunday: false)
        regime.save!
        regime
      end

      describe "#call" do

        context "when there are no changes to the regime" do

          it "does not create a new regime" do
            command = ReviseRegime.new(regime)
            expect { command.call({}) }.to_not change{ Regime.count }
          end

          it "returns true" do
            result = ReviseRegime.new(regime).call({})
            expect(result).to be_success
          end
        end

        context "when changes are invalid" do
          it "returns false" do
            command = ReviseRegime.new(regime)
            result = command.call({ start_date: "2015-12-01", end_date: "2014-12-01" })
            expect(result).to_not be_success
          end
        end

        context "when the regime has changes" do
          let(:params) { {} }
          it "does not create a new regime" do
            command = ReviseRegime.new(regime)
            expect { command.call({}) }.to_not change{ Regime.count }
          end
        end

        context "when there are changes to a bag but not the parent regime" do
          it "creates a new regime" do
            regime
            regime_count = Regime.count
            bag_count = RegimeBag.count

            bag = regime.bags.first

            # Bag volume and sunday change
            params = {
              "bags_attributes" => {
                "0" => {
                  "regime_id" => regime.id.to_s,
                  "bag_type_id" => bag.bag_type_id.to_s,
                  "volume" => (bag.volume + 1).to_s,
                  "_destroy" => "false",
                  "sunday" => "1",
                  "monday" => "1",
                  "tuesday" => "1",
                  "wednesday" => "1",
                  "thursday" => "1",
                  "friday" => "1",
                  "saturday" => "1",
                  "id" => bag.id.to_s }
              }
            }

            ReviseRegime.new(regime).call(params)

            expect(Regime.count).to eq(regime_count + 1)
            expect(RegimeBag.count).to eq(bag_count + 1)
          end
        end

        context "when a bag is deleted from a regime with one bag" do
          it "creates a new regime with just one bag" do
            regime.bags << build(:pd_regime_bag, sunday: false)
            regime_count = Regime.count
            bag_count = RegimeBag.count

            bag = regime.bags.first

            # Note "_destroy"=>"true",
            params = {
              "bags_attributes" => {
                "0" => {
                  "regime_id" => regime.id.to_s,
                  "bag_type_id" => bag.bag_type_id.to_s,
                  "volume" => (bag.volume + 1).to_s,
                  "_destroy" => "true",
                  "sunday" => "1",
                  "monday" => "1",
                  "tuesday" => "1",
                  "wednesday" => "1",
                  "thursday" => "1",
                  "friday" => "1",
                  "saturday" => "1",
                  "id" => bag.id.to_s }
              }
            }

            expect(regime.bags.count).to eq(2)
            result = ReviseRegime.new(regime).call(params)

            new_regime = result.regime
            expect(new_regime.bags.count).to eq(1)
            expect(regime.reload.bags.count).to eq(2)

            expect(Regime.count).to eq(regime_count + 1)
            expect(RegimeBag.count).to eq(bag_count + 1)

          end
        end

        context "when there are changes to the regime" do
          it "creates a new regime" do
            command = ReviseRegime.new(regime)
            expect { command.call({ add_hd: true }) }.to change{ Regime.count }.by(1)
          end

          it "the new regime is not the original regime" do
            new_regime = ReviseRegime.new(regime).call({ add_hd: true }).regime
            expect(new_regime).to be_present
            expect(new_regime.id).to be_present
            expect(new_regime.id).to_not eq(regime.id)
          end

          it "the new regime's bags are not those of the original" do
            result = ReviseRegime.new(regime).call({ add_hd: true })
            new_regime = result.regime
            original_bag_ids = regime.bags.map(&:id)
            new_bag_ids = new_regime.bags.map(&:id)
            expect(original_bag_ids - new_bag_ids).to eq(original_bag_ids)
          end
        end
      end
    end
  end
end
