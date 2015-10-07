require 'rails_helper'

module Renalware
  describe Permission, type: :lib do
    describe 'all' do
      subject { Permission.all }

      it 'contains system permissions for Renalware Renalware::Roles' do
        expect(subject.map(&:role).uniq).to match_array([:super_admin, :admin, :clinician, :read_only])
      end

      describe 'abilities for roles' do
        before do
          @super_admin_permission, @admin_permission,
            @clinical_permission, @clinical_read_permission,
              @readonly_permission = subject
        end

        it 'enables super admins to manage all' do
          expect(@super_admin_permission.ability).to eq(:manage)
          expect(@super_admin_permission.models).to eq(:all)
        end

        it 'enables admins to manage specific models' do
          expect(@admin_permission.ability).to eq(:manage)
          expect(@admin_permission.models).to include(Renalware::User)
          expect(@admin_permission.models).to include(Renalware::Drug)
          expect(@admin_permission.models).to include(Renalware::Patient)
        end

        it 'enables clinicians to manage common models' do
          expect(@clinical_permission.ability).to eq(:manage)
          expect(@clinical_permission.models).to include(Renalware::Patient)
          expect(@clinical_permission.models).not_to include(Renalware::Drug)
          expect(@clinical_permission.models).not_to include(Renalware::Role)
        end

        it 'enables clinicians to view admin models' do
          expect(@clinical_read_permission.ability).to eq(:read)
          expect(@clinical_read_permission.models).to include(Renalware::Drug)
        end

        it 'enables readonly users to read any model' do
          expect(@readonly_permission.ability).to eq(:read)
          expect(@readonly_permission.models).to eq(:all)
        end
      end
    end
  end
end