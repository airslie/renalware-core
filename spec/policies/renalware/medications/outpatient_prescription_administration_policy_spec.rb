module Renalware
  module Medications
    describe OutpatientPrescriptionAdministrationPolicy, type: :policy do
      include PolicySpecHelper

      let(:clinical_user) { user_double_with_role(:clinical) }
      let(:admin_user) { user_double_with_role(:admin) }
      let(:administration) { OutpatientPrescriptionAdministration.new }

      it "permits clinical users to access standard actions when enabled" do
        permissions = permissions_for(clinical_user, %i(index? new? create? edit? update?))

        expect(permissions).to all(be(true))
      end

      it "does not permit clinical users to destroy administrations" do
        expect(permission_for(clinical_user, :destroy?)).to be(false)
      end

      it "permits admin users to destroy administrations when enabled" do
        expect(permission_for(admin_user, :destroy?)).to be(true)
      end

      it "denies access to all outpatient administration actions when disabled" do
        allow(Renalware.config)
          .to receive(:outpatient_prescription_administration_enabled)
          .and_return(false)

        expect(permissions_for(admin_user, %i(index? new? create? edit? update? destroy?)))
          .to all(be(false))
      end

      def permissions_for(user, permissions)
        permissions.map { |permission| permission_for(user, permission) }
      end

      def permission_for(user, permission)
        described_class.new(user, administration).public_send(permission)
      end
    end
  end
end
