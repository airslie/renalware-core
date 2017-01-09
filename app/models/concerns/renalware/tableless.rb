module Renalware
  class Tableless < ActiveRecord::Base

    def self.columns
      @columns ||= []
    end

    def self.column(name, sql_type = nil, default = nil, null = true)
      type = "ActiveRecord::Type::#{sql_type.to_s.camelize}".constantize.new
      columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, type, null, "")
    end

    def self.columns_hash
      @columns_hash ||= Hash[columns.map { |column| [column.name, column] }]
    end

    def self.column_names
      @column_names ||= columns.map(&:name)
    end

    def self.column_defaults
      @column_defaults ||= begin
        columns.map { |column| [column.name, nil] }
               .each_with_object({}) do |e, m|
          m[e[0]] = e[1]
          m
        end
      end
    end

    # Override the save method to prevent exceptions.
    def save(validate = true)
      validate ? valid? : true
    end

    def self.load_schema!
      columns_hash.each do |name, column|
        define_attribute(
          name,
          column.sql_type_metadata,
          default: column.default,
          user_provided_default: false
        )
      end
    end
  end
end
