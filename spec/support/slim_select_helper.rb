module SlimSelectHelper
  # Capybara helper for selecting an option in a slim-select dropdown.
  # Assumption is that you have a label who's parent also contains the select list you
  # are choosing from.
  # Uses a trick to unhide the actual select box, and work with it,
  # instead of the slim_select instance, as that would both:
  # 1. Speed up tests, eliminating waits for animations
  # 2. Increase robustness, as no sleep(x), etc.
  #
  # Usage:
  #   slim_select 'Item name', from: 'Label text
  #
  def slim_select(item_text, options)
    expect(page).to have_field(options[:from], visible: :all)
    select_box = find_field(options[:from], visible: :all)

    if Capybara.current_driver != :rack_test
      page.execute_script(
        "arguments[0].style.display = 'block'",
        select_box
      )
    end

    # !!Since slim-select 2.10.0 we need to select the option TWICE!
    2.times { select item_text, from: options[:from] }
  end
end
