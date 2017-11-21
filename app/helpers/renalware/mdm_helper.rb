module Renalware
  module MDMHelper
    def link_to_mdm(patient)
      MDMLink.new(patient).to_html
    end

    #
    # Create an html link to the MDM appropriate to the patient's current modality
    #
    class MDMLink
      include ActionView::Helpers
      include Renalware::Engine.routes.url_helpers

      def initialize(patient)
        @patient = patient
      end

      def path
        @path ||= begin
          case modality_description_name&.downcase&.to_sym
          when :pd then patient_pd_mdm_path(patient)
          when :hd then patient_hd_mdm_path(patient)
          when :transplant then patient_transplants_mdm_path(patient)
          when :lcc then nil # patient_low_clearance_mdm_path(patient)
          end
        end
      end

      def to_html
        link_to(mdm_name, path) if path
      end

      private

      attr_reader :patient, :modality_description_name

      def modality_description_name
        modality_description.name
      end

      def modality_description
        current_modality = patient.current_modality || NullObject.instance
        current_modality.description
      end

      def mdm_name
        "#{modality_description_name} MDM"
      end
    end
  end
end
