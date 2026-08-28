module Renalware
  module Letters
    class Author < Renalware::User
      # rubocop:disable-next Rails/RedundantForeignKey
      has_many :letters, dependent: :restrict_with_exception, foreign_key: :author_id
    end
  end
end
