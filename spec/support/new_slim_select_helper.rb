module NewSlimSelectHelper
  # This is a replacement for SlimSelectHelper
  # Once all uses of slim_select and slim_select_ajax have
  # been switched over to this one we can remove the old module
  # and rename this one.
  def slim_select(item_text, options)
    expect(page).to have_field(options[:from], visible: :all)
    select_box = find_field(options[:from], visible: :all)
    data_id = select_box["data-id"]

    # Click on the dropdown to show it
    find(".ss-main[data-id='#{data_id}'] .ss-arrow").click
    expect(page).to have_field "Search"

    # Click on the appropriate item in the list
    within(".ss-content[data-id='#{data_id}']") do
      find(".ss-option", text: item_text).click
    end

    # Ensure drop down has disappeared before continuing
    expect(page).to have_no_css("div.ss-list")
  end
end
