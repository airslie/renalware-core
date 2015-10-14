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
  #         t.jsonb :document
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
  #       class RecipientWorkupDocument < Document::Embedded
  #         attribute :hx_tb, Boolean
  #         attribute :hx_dvt, Boolean
  #         attribute :pregnancies_no, Integer
  #         attribute :cervical_result, String
  #         attribute :cervical_date, Date
  #
  #         class Consent < Document::Embedded
  #           attribute :consent, Boolean
  #           attribute :consent_date, Date
  #
  #           validates_presence_of :consent_date, if: :consent
  #         end
  #
  #         validates_presence_of :cervical_date
  #       end
  #     end
  #   end
  #
  # You then include the {Document::Base} module in the parent ActiveRecord
  # and provide the document class to use.
  #
  # For instance:
  #
  #   module Renalware
  #     module Transplants
  #       class RecipientWorkup < ActiveRecord::Base
  #         include Document::Base
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
  #         renalware/transplants/recipient_workup_document/consent:
  #           consent: Tx consent?
  #           consent_date: Tx consent date
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
  #   = f.simple_fields_for :document do |fd|
  #     = fd.input :hx_tb, as: :boolean
  #     = fd.input :hx_dvt, as: :boolean
  #     = fd.input :cervical_date, as: :date
  #     = fd.simple_fields_for :consent, fd.object.consent do |fdd|
  #       = fdd.input :consent
  #       = fdd.input :consent_date, as: :date
  #
  #
  class Embedded
    include Virtus.model
    include ActiveModel::Model
    extend Enumerize

    # Assign a default value to the attributes using a custom type.
    # Set a validation on nested object.
    #
    # You can specify an enum attribute by passing the `enums` options:
    #
    #   attribute :gender, enums: [:male, :female]
    #
    # For a confirmation attribute (yes, no, unknown), pass `:confirmation`
    # as the enums array:
    #
    #   attribute :accepted, enums: :confirmation
    #
    # For a yes/no attribute, pass `:yes_no` as the enums array:
    #
    #   attribute :accepted, enums: :yes_no
    #
    def self.attribute(*args)
      options = args.extract_options!
      name, type = *args
      if type && type.included_modules.include?(ActiveModel::Model)
        options.reverse_merge!(default: type.send(:new))

        # Add validation
        validate "#{name}_valid".to_sym

        # Validation method
        define_method("#{name}_valid".to_sym) do
          errors.add(name.to_sym, :invalid) if send(name).invalid?
        end
      else
        enums = options[:enums]
        case enums
        when :confirmation
          enums = %i(yes no unknown)
        when :yes_no
          enums = %i(yes no)
        end
      end
      super(name, type, options)
      enumerize name, in: enums if enums
    end

    # Returns a list of the Virtus attributes in the model
    def self.attributes_list
      attribute_set.entries.map(&:name)
    end


    @@methods_to_ignore = []

    # Flag an old attribute to be ignored
    # when the document is deserialized from the database
    #
    #   class RecipientWorkupDocument < Document::Base
    #     old_attribute :hx_tb
    #   end
    def self.old_attribute(attribute)
      @@methods_to_ignore << attribute
      @@methods_to_ignore << "#{attribute}=".to_sym
    end

    # Flag a list of old attribtues to be ignored
    # when the document is deserialized from the database
    #
    #   class RecipientWorkupDocument < Document::Base
    #     old_attributes :hx_tb, :hx_tb_date, :foo_bar
    #   end
    def self.old_attributes(*list)
      list.each { |item| old_attribute(item) }
    end

    # Don't raise exception if known missing attribute
    def method_missing(method_sym, *arguments, &block)
      super unless @@methods_to_ignore.include? method_sym
    end
  end
end
