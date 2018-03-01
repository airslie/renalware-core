# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Feeds
    module Files
      module PracticeMemberships
        describe ImportJob do
          context "when importing epracmem.zip" do
            it "calls ImportCSV to do the work" do
              file = create(
                :feed_file,
                :practices,
                location: file_fixture("practice_memberships/epracmem.zip")
              )
              create(:united_kingdom)
              expect_any_instance_of(PracticeMemberships::ImportCSV)
               .to receive(:call)
               .exactly(:once)

              described_class.new.perform(file)
            end
          end
        end
      end
    end
  end
end
