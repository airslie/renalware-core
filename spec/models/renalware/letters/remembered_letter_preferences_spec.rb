require "rails_helper"

module Renalware
  module Letters
    RSpec.describe RememberedLetterPreferences, type: :model do

      describe "#persist" do
        it "saves certain model attributes to the session" do
          letter = double("Letter",
                          letterhead_id: 1,
                          description: "1",
                          author_id: 1,
                          issued_on: Date.today)
          session = {}

          RememberedLetterPreferences.new(session).persist(letter)

          RememberedLetterPreferences::ATTRIBUTES_TO_REMEMBER.each do |attr|
            expect(session[:letter_preferences]).to have_key(attr)
          end
        end
      end

      describe "#apply_to" do
        it "copies any previously remembered session data to the letter" do
          session = {
            letter_preferences: {
              letterhead_id: 1,
              description: "1",
              author_id: 1,
              issued_on: Date.today
            }
          }
          letter = OpenStruct.new(letterhead_id: nil,
                                  description: nil,
                                  author_id: nil,
                                  issued_on: nil)

          RememberedLetterPreferences.new(session).apply_to(letter)

          RememberedLetterPreferences::ATTRIBUTES_TO_REMEMBER.each do |attr|
            expect(letter.public_send(attr)).to eq(session[:letter_preferences][attr])
          end
        end
      end
    end
  end
end
