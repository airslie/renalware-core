module Renalware
  module Patients
    class PatientListener
      def patient_modality_changed_to_death(args)
        ClearPatientUKRDCData.call(patient: args[:patient], by: args[:actor])
      end

      # A patient was accidentally deceased in the EHR, and we have received a message
      # that indicates they are no longer deceased.
      # We have already at this point updated the patient's died_on date to nil,
      # but we need to notify superadmins that some intervention is required with this patient
      # eg to reinstate prescriptions, UKRDC data etc.
      def patient_undeceased(patient:, **)
        Messaging::Internal::SendMessageToUsersWithRole.call(
          author: SystemUser.find,
          patient: patient,
          role_name: :super_admin,
          subject: "Patient #{patient} was undeceased!",
          body: <<~MESSAGE
            The patient #{patient} was previously deceased but we have received an HL7 message
            indicating that they are no longer deceased. Please check the Renalware patient record
            and take any necessary action, such as reinstating prescriptions or UKRDC preferences.
            NHS: #{patient.nhs_number}
          MESSAGE
        )
      end
    end
  end
end
