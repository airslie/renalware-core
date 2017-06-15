require_dependency "renalware/feeds"

module Renalware
  module Feeds
    module Files
      module Practices
        class CSVFile
          include Virtus.model
          attribute :dir, Pathname

          def create
            path = ::File.join(dir, "practices.csv")
            CSV.open(path, "wb", quote_char: '"', force_quotes: false) do |csv|
              csv << CSVOrganisation.headers
              yield(csv)
            end
            path
          end
        end
      end
    end
  end
end
