# frozen_string_literal: true

module Renalware
  module Patients
    class PatientPolicy < BasePolicy
      class Scope
        attr_reader :user, :scope

        def initialize(user, scope)
          @user = user
          @scope = scope
        end

        # For each role define e.g. user_is_admin?
        Role::ROLES.each do |role|
          define_method :"user_is_#{role}?" do
            user.has_role?(role)
          end
        end

        def resolve
          # Here is the gruesome logic
          # RF HEROIC user - sees HEROIC patients at RF and RL, and all non-HEROIC patients at RF
          # RL HEROIC user - sees HEROIC patients at RL and RF and all non-HEROIC patients at RL
          # RF non-HEROIC user - sees all non-HEROIC patients at RF
          # RL non-HEROIC user - sees all patients at RL including HEROIC patient
          #
          # Attributes we have to play with
          # - patient.hospital_centre
          # - user.hospital_centre
          # - user.investigatorships
          # - user.participations
          #
          # The ideal scenario
          # - a SQL view where we say can this user access this patient?
          # looks like this with compound key
          # user_id, patient_id
          # 1        11
          # would be built using the above logic
          # if mat view would need to be async
          # PatientAccess.where(user: user, patient: patient)
          # 300 30000 => 9,000,000
          # or we could do it by exclusion so we list exclusions
          #  # user_id, patient_id
          # 1        11
          # user 1 cannot see patient 11
          # still if there are 30 users at another site nearly a million rows
          # use 'left join patient_access where patient_id is null'
          #
          # So here we use top level roles first
          return Renalware::Patient.all if user_is_super_admin?

          scope = nil
          # If the user works at the host site then they can see any patient at that site
          if user.hospital_centre&.host_site?
            scope = Renalware::Patient.where(hospital_centre_id: user.hospital_centre_id)
          end
          scope || Renalware::Patient.none
          # user.hospital_centre_id = patient.hosiptal_centre_id
          # letft outer join study_access
          # study_access
          # patient_id, user_id, study_ids, net_visible
          # 1            11      [123,1]     true   # user is investigator in private study
          # This works!
          #scope.joins("left join user_patient_bans on user_patient_bans.patient_id = patients.id and user_patient_bans.user_id = #{user.id} where user_patient_bans.patient_id is null")

          # something abut the study tells us the access also
          # left outer join research_patients_in_private_studies priv_pat on priv_pat.patient_id = patients.id
          # left outer join research_private_access priv_acc on priv_acc.patient_id = patients.id && priv_acc.user_id = #{user.id}
          # where priv_pat is null # ie not in a provate study
          # or priv_acc.user is not null # ie they are provate but wee have access

          # another way
          # some kind of code checksum binary bitwise & |
        end
      end
    end
  end
end
