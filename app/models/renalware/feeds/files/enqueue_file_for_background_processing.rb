require "renalware/feeds"

module Renalware
  module Feeds
    module Files
      class EnqueueFileForBackgroundProcessing
        def self.call(file)
          new.call(file)
        end

        def call(file)
          job_class = ImportJobFactory.job_class_for(file.file_type)
          job_class.perform_later(file)
        end
      end
    end
  end
end
