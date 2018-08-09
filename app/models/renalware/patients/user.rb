# frozen_string_literal: true

module Renalware
  module Patients
    class User < ActiveType::Record[Renalware::User]
      has_many :bookmarks, dependent: :restrict_with_exception
      has_many :patients, through: :bookmarks

      def bookmark_for_patient(patient)
        bookmarks.find_by(patient: patient)
      end
    end
  end
end
