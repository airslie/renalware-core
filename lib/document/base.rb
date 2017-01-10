module Document
  module Base
    extend ActiveSupport::Concern

    class_methods do
      def has_document(options)
        class_name = options[:class_name]
        document_class = self.const_get(class_name)

        define_method("document_class".to_sym) do
          document_class
        end
      end
    end

    included do
      class_eval do
        validate :document_valid

        after_initialize :initialize_document, if: :new_record?
        before_save :serialize_document
      end

      # Note that unless you specify a default value in the migration when defining your jsonb
      # column e.g.
      #   add_column :users, :meta2, :jsonb, default: {}
      # then the default value in rails 5 is "{}" and rails 4 is {}.
      # According to this issue the default in 4.2 was a bug and "{}" is correct.
      # https://github.com/rails/rails/issues/25594
      def document
        @document ||= begin
          value = read_attribute(:document)
          value = ::ActiveSupport::JSON.decode(value) if value.is_a? String
          document_class.new(value)
        end
      end

      def document=(attributes)
        return unless attributes.present?
        filtered_attributes = filter_date_params(attributes)
        @document = document_class.new(filtered_attributes)
        serialize_document
      end

      private

      def initialize_document
        write_attribute(:document, {}.to_json)
      end

      def serialize_document
        write_attribute(:document, document.to_json)
      end

      def filter_date_params(params)
        params = (params ? params.dup : {}) # DISCUSS: not sure if that slows down form processing?
        date_attributes = {}

        params.each do |attribute, value|
          if value.is_a?(Hash)
            params[attribute] = filter_date_params(value)
          elsif (matches = attribute.match(/^(\w+)\(.i\)$/))
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
          Time.zone ? Time.zone.local(*args) : Time.new(*args)
        end
      end

      def document_valid
        errors.add(:base, :invalid) unless document.valid?
      end
    end
  end
end
