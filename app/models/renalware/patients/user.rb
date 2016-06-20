module Renalware
  module Patients
    class User < ActiveType::Record[Renalware::User]
      has_many :bookmarks
      has_many :patients, through: :bookmarks
    end
  end
end
