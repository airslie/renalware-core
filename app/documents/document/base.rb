module Document
  module Base
    extend ActiveSupport::Concern

    class_methods do
      def has_document(class_name: "Document")
        document_class = const_get(class_name)

        define_method(:document_class) do
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

      def document
        @document ||= begin
          value = read_attribute(:document)
          document_class.new(value)
        end
      end

      def document=(attributes)
        return if attributes.blank?

        filtered_attributes = filter_date_params(attributes)
        @document = document_class.new(filtered_attributes)
        serialize_document
      end

      private

      def initialize_document
        write_attribute(:document, {})
      end

      def serialize_document
        write_attribute(:document, document)
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
          Time.zone ? Time.zone.local(*args) : Time.zone.new(*args)
        end
      end

      def document_valid
        return if document.valid?

        add_document_errors(document, ["document"])
      end

      def add_document_errors(document_part, path)
        document_part.errors.each do |error|
          attribute = error.attribute
          child = child_document_for(document_part, attribute)

          if child.respond_to?(:errors) && child.errors.any?
            add_document_errors(child, path + [attribute])
          else
            add_document_error(path, error)
          end
        end
      end

      def child_document_for(document_part, attribute)
        return if attribute == :base
        return unless document_part.respond_to?(attribute)

        document_part.public_send(attribute)
      end

      def add_document_error(path, error)
        if error.attribute == :base
          errors.add(:base, error.message)
        else
          errors.add((path + [error.attribute]).join("."), error.message)
        end
      end
    end
  end
end
