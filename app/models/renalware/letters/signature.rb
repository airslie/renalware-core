require_dependency "renalware/letters"

module Renalware
  module Letters
    class Signature < ActiveRecord::Base
      belongs_to :user
      belongs_to :letter

      validates_presence_of :user, :letter, :signed_at

      def to_s
        name = user.full_name
        time = I18n.l(signed_at, format: :time)
        date = I18n.l(signed_at.to_date)
        "Electronically signed by #{name} at #{time} on #{date}".upcase
      end
    end
  end
end