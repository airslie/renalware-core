module Renalware
  module PD
    describe RegimeForModalityQuery do
      subject(:resolved_regime) { described_class.new(modality:).call }

      let(:user) { create(:user, :minimal) }
      let(:patient) { create(:patient) }
      let(:modality_started_on) { Date.current }
      let(:modality) do
        create(
          :modality,
          description: create(:pd_modality_description),
          patient:,
          started_on: modality_started_on
        )
      end

      def create_apd_regime(start_date:, end_date: nil, regime_patient: patient)
        create(
          :apd_regime,
          patient: regime_patient,
          start_date:,
          end_date:,
          bags: [build(:pd_regime_bag, :everyday)]
        )
      end

      context "when the patient has no PD regime" do
        it { is_expected.to be_nil }
      end

      context "when the patient has a PD regime active on the modality start date" do
        it "returns the active regime" do
          regime = create_apd_regime(start_date: 1.year.ago, end_date: nil)

          expect(resolved_regime).to eq(regime)
        end

        it "returns the active regime closest to the modality start date" do
          create_apd_regime(start_date: 1.year.ago, end_date: nil)
          regime = create_apd_regime(start_date: modality_started_on - 1.day, end_date: nil)

          expect(resolved_regime).to eq(regime)
        end
      end

      context "when the patient has a PD regime ending on the modality start date" do
        it "does not return the ended regime" do
          create_apd_regime(start_date: 1.year.ago, end_date: modality_started_on)

          expect(resolved_regime).to be_nil
        end
      end

      context "when the patient has a PD regime created on the modality start date" do
        it "returns the regime" do
          regime = create_apd_regime(start_date: modality_started_on)

          expect(resolved_regime).to eq(regime)
        end
      end

      context "when the patient has several regimes created on the same day" do
        it "returns the last one created that day" do
          regimes = []
          travel_to modality_started_on do
            regimes << create_apd_regime(start_date: Time.zone.now, end_date: nil)
          end

          travel_to modality_started_on + 1.minute do
            result = ReviseRegime.new(regimes[0]).call(by: user, params: { add_hd: true })
            regimes << result.object
          end

          travel_to modality_started_on + 2.minutes do
            result = ReviseRegime.new(regimes[1]).call(by: user, params: { add_hd: false })
            regimes << result.object
          end

          expect(resolved_regime).to eq(regimes.last)
        end
      end

      context "when there is no active regime but one starts within 14 days" do
        it "returns the first regime after the modality start date" do
          regime = create_apd_regime(start_date: modality_started_on + 14.days)

          expect(resolved_regime).to eq(regime)
        end

        it "returns the earliest regime after the modality start date" do
          create_apd_regime(start_date: modality_started_on + 14.days)
          regime = create_apd_regime(start_date: modality_started_on + 1.day)

          expect(resolved_regime).to eq(regime)
        end
      end

      context "when there is no active regime and one starts more than 14 days later" do
        it "does not return the future regime" do
          create_apd_regime(start_date: modality_started_on + 15.days)

          expect(resolved_regime).to be_nil
        end
      end

      context "when there are active and future regimes" do
        it "prefers the active regime" do
          active_regime = create_apd_regime(start_date: 1.year.ago, end_date: nil)
          create_apd_regime(start_date: modality_started_on + 1.day, end_date: nil)

          expect(resolved_regime).to eq(active_regime)
        end
      end

      context "when another patient's regime matches the modality date" do
        it "does not return that regime" do
          create_apd_regime(
            start_date: modality_started_on,
            regime_patient: create(:patient)
          )

          expect(resolved_regime).to be_nil
        end
      end
    end
  end
end
