require "rails_helper"

describe Renalware::StepIndicatorComponent, type: :component do
  it "marks completed and current steps" do
    render_inline(
      described_class.new(
        steps: [
          { key: :upload, label: "Upload" },
          { key: :preview, label: "Preview" },
          { key: :review, label: "Review" }
        ],
        current_step: :preview
      )
    )

    expect(page).to have_css("nav[aria-label='Progress']")
    expect(page).to have_css("li[aria-current='step']", text: "Preview")
    expect(page).to have_text("Upload")
    expect(page).to have_text("Review")
  end
end
