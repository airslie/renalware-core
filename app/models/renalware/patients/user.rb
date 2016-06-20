module Renalware
  module Patients
    class User < ActiveType::Record[Renalware::User]
      has_many :bookmarks
      has_many :patients, through: :bookmarks

      def has_bookmarked?(patient)
        patients.include?(patient)
      end
    end
  end
end
