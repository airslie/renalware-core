module Document
  # This concern wraps the logic for embedding document in an active record object.
  # The document fields are stored in a jsonb column. The database migration
  # should look like this:
  #
  #   class CreateRenalwareTransplantRecipientWorkups < ActiveRecord::Migration
  #     def change
  #       create_table :transplants_recipient_workups do |t|
  #         t.belongs_to :patient, index: true, foreign_key: true
  #         t.timestamp :performed_at
  #         t.jsonb :document, null: false, default: '{}'
  #         t.text :notes
  #
  #         t.timestamps null: false
  #       end
  #
  #       add_index :transplants_recipient_workups, :document, using: :gin
  #     end
  #   end
  #
  # You then have to create a class for the document under _/app/documents_
  # and provide a list of the attributes following the Virtus conventions.
  #
  # The class also includes the ActiveModel::Model module so you can use validations.
  #
  # Here's an example:
  #
  #   module Renalware
  #     module Transplants
  #       class RecipientWorkupDocument < Document::Base
  #         attribute :hx_tb, Boolean
  #         attribute :hx_dvt, Boolean
  #         attribute :pregnancies_no, Integer
  #         attribute :cervical_result, String
  #         attribute :cervical_date, Date
  #         attribute :tx_consent, Boolean
  #         attribute :tx_consent_date, Date
  #
  #         validates_presence_of :cervical_date
  #         validates_presence_of :tx_consent_date, if: :tx_consent
  #       end
  #     end
  #   end
  #
  # You then include the {Document::Embedded} module in the parent ActiveRecord
  # and provide the document class to use.
  #
  # For instance:
  #
  #   module Renalware
  #     module Transplants
  #       class RecipientWorkup < ActiveRecord::Base
  #         include Document::Embedded
  #         has_document class_name: "RecipientWorkupDocument"
  #       end
  #     end
  #   end
  #
  # The document attributes can be localized, but a special convention must be followed
  # due to the namespaces, especially for simple_form.  Simply create a file
  # under _config/locales_ and provide the fields localization:
  #
  #   en:
  #     activemodel:
  #       attributes:
  #         renalware/transplants/recipient_workup_document:
  #           hx_tb: History of TB?
  #           hx_dvt: History of DVT?
  #           pregnancies_no: Number of pregnancies
  #           cervical_result: Cervical smear result
  #           cervical_date: Cervical smear date
  #           tx_consent: Tx consent?
  #           tx_consent_date: Tx consent date
  #     simple_form:
  #       hints:
  #         transplants_recipient_workup:
  #           cervical_date: The date and time of the cervical
  #           document:
  #             cervical_date: Just a date
  #       placeholders:
  #         transplants_recipient_workup:
  #           document:
  #             pregnancies_no: "0"
  #
  # Then in a form, you simply use the form builder fields_for helper:
  #
  #   = f.fields_for :document do |fd|
  #     = fd.input :hx_tb, as: :boolean
  #     = fd.input :hx_dvt, as: :boolean
  #     = fd.input :cervical_date, as: :date
  #
  # The controller will also need to handle strong parameters.  {Document::Base} provides
  # an helper for a list of the attributes in the document class.  Here's an example
  # of a params method in a controller:
  #
  #   def workup_params
  #     fields = [
  #       :performed_at, :notes,
  #       { document_attributes: RecipientWorkupDocument.fields }
  #     ]
  #     params.require(:transplants_recipient_workup).permit(fields)
  #   end
  #
  module Embedded
    extend ActiveSupport::Concern

    class_methods do
      def has_document(options)
        class_name = options[:class_name]
        @document_class = self.const_get(class_name)
        serialize :document, @document_class
      end

      def document_attributes
        @document_class.attributes_list
      end
    end

    included do
      class_eval do
        validate :document_valid
      end

      def document_attributes=(value)
        filtered_value = filter_date_params(value)
        document.attributes = filtered_value
      end

      def document_attributes
        document.attributes
      end

      protected

      def filter_date_params(params)
        params = params.dup # DISCUSS: not sure if that slows down form processing?
        date_attributes = {}

        params.each do |attribute, value|
          if value.is_a?(Hash)
            # TODO: #validate should only handle local form params.
            params[attribute] = filter_date_params(value)
          elsif matches = attribute.match(/^(\w+)\(.i\)$/)
            date_attribute = matches[1]
            date_attributes[date_attribute] = params_to_date(
              params.delete("#{date_attribute}(1i)"),
              params.delete("#{date_attribute}(2i)"),
              params.delete("#{date_attribute}(3i)"),
              params.delete("#{date_attribute}(4i)"),
              params.delete("#{date_attribute}(5i)")
            )
          end
        end
        params.merge!(date_attributes)
      end

      def params_to_date(year, month, day, hour, minute)
        date_fields = [year, month, day].map!(&:to_i)
        time_fields = [hour, minute].map!(&:to_i)

        if date_fields.any?(&:zero?) || !Date.valid_date?(*date_fields)
          return nil
        end

        if hour.blank? && minute.blank?
          Date.new(*date_fields)
        else
          args = date_fields + time_fields
          Time.zone ? Time.zone.local(*args) :
            Time.new(*args)
        end
      end

      def document_valid
        errors.add(:base, 'Invalid document') unless document.valid?
      end
    end
  end
end