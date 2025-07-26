module Renalware
  module HD
    describe AcuityAssessmentPolicy, type: :policy do
      subject(:policy) { described_class }

      let(:other_user) { create(:user, :clinical) }
      let(:created_at) { Time.current }
      let(:created_by) { create(:user, :clinical) }
      let(:assessment) do
        create(:hd_acuity_assessment, created_at:, by: created_by)
      end

      %i(edit? destroy?).each do |permission|
        permissions permission do
          context "when the creation date is outside the deletion window" do
            let(:created_at) { 13.hours.ago }

            it do
              is_expected.not_to permit(created_by, assessment)
              is_expected.not_to permit(other_user, assessment)
            end
          end

          context "when the creation date is within the deletion window" do
            let(:created_at) { 11.hours.ago }

            it do
              is_expected.to permit(created_by, assessment)
              is_expected.not_to permit(other_user, assessment) # no owner
            end
          end
        end
      end
    end
  end
end
