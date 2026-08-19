module Renalware
  module Transplants
    describe UKTDeathCause do
      subject { build(:transplant_ukt_death_cause) }

      it { is_expected.to validate_presence_of(:code) }
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_presence_of(:position) }
      it { is_expected.to validate_uniqueness_of(:code) }
      it { is_expected.to validate_uniqueness_of(:name) }
      it { is_expected.to have_db_index(:code).unique(true) }
      it { is_expected.to have_db_index(:name).unique(true) }

      describe ".pluck_for_dropdown" do
        it "returns enabled causes in position and name order as labels and stored codes" do
          create(:transplant_ukt_death_cause, code: "b", name: "B", position: 2)
          create(:transplant_ukt_death_cause, code: "a2", name: "A2", position: 1)
          create(:transplant_ukt_death_cause, code: "a1", name: "A1", position: 1)
          create(:transplant_ukt_death_cause, code: "hidden", name: "Hidden", enabled: false)

          expect(described_class.pluck_for_dropdown).to eq(
            [%w(A1 a1), %w(A2 a2), %w(B b)]
          )
        end
      end
    end
  end
end
