require "csv"

module Renalware
  module Drugs
    module DMDMigration
      # Imports reviewed mappings only. Prescription conversion is a separate operation.
      class MatchImport
        include ActiveModel::Model
        include ActiveModel::Attributes

        HEADERS = %w(drug_name vtm_name approved_vtm_match trade_family_name
                     approved_trade_family_match).freeze
        BOOLEANS = { "TRUE" => true, "T" => true, "FALSE" => false, "F" => false,
                     "" => false }.freeze

        attribute :file
        attribute :validate_only, :boolean, default: true
        attr_reader :imported_count

        validate { errors.add(:file, file ? :invalid : :blank) unless file.respond_to?(:read) }

        def save
          return false unless valid?

          DMDMatch.transaction do
            rows = read_rows
            changes = rows && prepare_changes(rows)
            raise ActiveRecord::Rollback if errors.any?

            changes.each { |match, attributes| match.update!(attributes) } unless validate_only
            @imported_count = changes.length
          end
          errors.empty?
        rescue CSV::MalformedCSVError, Encoding::InvalidByteSequenceError => e
          errors.add(:file, "could not be read as CSV: #{e.message}")
          false
        end

        private

        def read_rows
          file.rewind
          rows = CSV.parse(csv_content, headers: true)
          missing = HEADERS - Array(rows.headers)
          errors.add(:file, "is missing columns: #{missing.join(', ')}") if missing.any?
          errors.add(:file, "contains no mappings") if rows.empty?
          errors.add(:file, "has duplicate headings") if rows.headers.uniq != rows.headers
          rows if errors.empty?
        end

        def csv_content
          content = file.read.force_encoding(Encoding::UTF_8)
          raise Encoding::InvalidByteSequenceError, "must be UTF-8" unless content.valid_encoding?

          content.delete_prefix("\uFEFF")
        end

        def prepare_changes(rows)
          matches = DMDMatch.where(drug_name: rows.pluck("drug_name")).includes(:drug)
            .lock.group_by(&:drug_name)
          seen = Set.new
          rows.each_with_index.filter_map do |row, index|
            label = "Row #{index + 2} (#{row['drug_name']})"
            candidates = matches.fetch(row["drug_name"], [])
            validate_source(row, candidates, seen, label)
            attributes = mapping_attributes(row, label)
            [candidates.first, attributes] if candidates.one?
          end
        end

        def validate_source(row, candidates, seen, label)
          if row["drug_name"].blank? || !candidates.one?
            errors.add(:file, "#{label}: drug name must match exactly one local mapping")
          end
          unless seen.add?(row["drug_name"])
            errors.add(:file, "#{label}: duplicate drug name in CSV")
          end
          return unless candidates.one?

          unless legacy_drug_matches?(candidates.first, row["drug_name"])
            errors.add(:file, "#{label}: mapping must reference the corresponding legacy drug")
          end
        end

        def legacy_drug_matches?(match, name)
          drug = match.drug
          drug && drug.name == name && drug.code.nil?
        end

        def destinations
          @destinations ||= {
            "vtm_name" => Drug.active.where.not(code: nil).pluck(:name).tally,
            "trade_family_name" => TradeFamily.pluck(:name).tally,
            "form_name" => Drugs::Form.pluck(:name).tally
          }
        end

        def mapping_attributes(row, label)
          attributes = %w(vtm trade_family).each_with_object({}) do |kind, result|
            approval = "approved_#{kind}_match"
            result[approval] = approved?(row[approval], approval, label)
            name = "#{kind}_name"
            result[name] = row[name].presence
            validate_destination(name, row[name], label) if result[approval]
          end
          if row.headers.include?("form_name")
            attributes["form_name"] = row["form_name"].presence
            validate_destination("form_name", row["form_name"], label) if row["form_name"].present?
          end
          attributes
        end

        def approved?(value, column, label)
          normalized = value.to_s.strip.upcase
          unless BOOLEANS.key?(normalized)
            errors.add(:file, "#{label}: #{column} must be TRUE, FALSE or blank")
          end
          BOOLEANS[normalized] || false
        end

        def validate_destination(column, name, label)
          return if name.present? && destinations.fetch(column)[name] == 1

          errors.add(:file, "#{label}: #{column} must match exactly one available catalogue entry")
        end
      end
    end
  end
end
