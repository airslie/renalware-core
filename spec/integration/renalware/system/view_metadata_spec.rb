# frozen_string_literal: true

require "rails_helper"

describe Renalware::System::ViewMetadata, type: :request do
  describe "#edit HTML" do
    it "renders a form" do
      view = create(:view_metadata)

      get edit_system_view_metadatum_path(view)

      expect(response).to be_success
      expect(response.body).to match("Edit")
    end
  end

  context "when params are valid" do
    describe "#update HTML" do
      it "udpates view metadata content" do
        view = create(:view_metadata)
        attributes = attributes_for(:view_metadata)
        # attributes[:columns] = %w(age sex) # TODO: populate columns
        attributes[:filters] = { "sex" => "search" }

        patch(
          system_view_metadatum_path(view),
          params: { view_metadata: attributes }
        )

        expect(response).to be_redirect
        follow_redirect!

        expect(view.reload).to have_attributes(attributes)
      end
    end
  end
end
