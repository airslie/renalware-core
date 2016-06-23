module Renalware
  module Patients
    class User < ActiveType::Record[Renalware::User]
      has_many :bookmarks
      has_many :patients, through: :bookmarks

      def bookmark_for_patient(patient)
        bookmarks.find_by(patient: patient)
      end
    end
  end
end
