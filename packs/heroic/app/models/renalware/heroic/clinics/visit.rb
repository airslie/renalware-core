# frozen_string_literal: true

module Renalware
  module Heroic
    module Clinics
      class Visit < ::Renalware::Clinics::ClinicVisit
        include ::Document::Base

        # We are not fans of callbacks but in this instance, becuase we don't have a decicated
        # controller for this type of clinic visit (it reuses the standard clinic visits controller)
        # I think it is forgiveable. An alterrnatives might be to use a command object to save the
        # visit, and we implement our own command object here and move the callback logic
        # into it. This would be nicer, but for now we are staying lightweight unless other
        # instances of ClinicVisit before- or after- functionality pop up.
        before_save :copy_lowest_heroic_bp_into_standard_visit_bp

        def self.policy_class
          Renalware::Clinics::ClinicVisitPolicy
        end

        class Document < Heroic::Document
          attribute :visit_number, Integer
          attribute :cuff_size, ::Document::Enum
          attribute :physical_activity, ::Document::Enum

          validates :visit_number,
                    allow_nil: true,
                    numericality: {
                      only_integer: true,
                      greater_than_or_equal_to: 0,
                      less_than_or_equal_to: 5
                    }

          class Smoking < Heroic::Document
            attribute :history, ::Document::Enum
            attribute :number, Integer
            attribute :ecigarettes, ::Document::Enum

            validates :number,
                      numericality: {
                        only_integer: true,
                        greater_than_or_equal_to: 0,
                        less_than_or_equal_to: 100
                      },
                      allow_nil: true
          end
          attribute :smoking, Smoking

          class Alcohol < Heroic::Document
            attribute :history, ::Document::Enum
            attribute :units, Integer

            validates :units,
                      numericality: {
                        only_integer: true,
                        greater_than_or_equal_to: 0,
                        less_than_or_equal_to: 20
                      },
                      allow_nil: true
          end
          attribute :alcohol, Alcohol

          class Urinalysis < Heroic::Document
            attribute :glucose, ::Document::Enum
            attribute :nitrate, ::Document::Enum
            attribute :leucocytes, ::Document::Enum
            attribute :specific_gravity, ::Document::Enum
          end
          attribute :urinalysis, Urinalysis

          # Aka EQ-5D-5L
          class HealthStatus < Heroic::Document
            attribute :mobility, ::Document::Enum
            attribute :self_care, ::Document::Enum
            attribute :usual_activities, ::Document::Enum
            attribute :pain, ::Document::Enum
            attribute :anxiety, ::Document::Enum
            attribute :health_today_out_of_100, Integer

            validates :health_today_out_of_100,
                      numericality: {
                        only_integer: true,
                        greater_than_or_equal_to: 1,
                        less_than_or_equal_to: 100
                      },
                      allow_nil: true
          end
          attribute :health_status, HealthStatus

          attribute :blood_pressure1, Renalware::BloodPressure
          attribute :blood_pressure2, Renalware::BloodPressure
          attribute :blood_pressure3, Renalware::BloodPressure
        end
        has_document

        def to_form_partial_path
          "/renalware/heroic/clinics/visits/visit_specific_form_fields"
        end

        # Doing this means we can track the bp in the Clinic Visit list
        def copy_lowest_heroic_bp_into_standard_visit_bp
          heroic_bps = Array.new(3) do |index|
            document.public_send(:"blood_pressure#{index + 1}")
          end
          lowest_heroic_bp = heroic_bps.min
          return unless lowest_heroic_bp

          self.diastolic_bp = lowest_heroic_bp.diastolic
          self.systolic_bp = lowest_heroic_bp.systolic
        end
      end
    end
  end
end
