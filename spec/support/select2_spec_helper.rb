# frozen_string_literal: true

module Select2SpecHelper
  def select2(value, opts)
    scope = opts[:from]
    select2_container = first("#{scope} + .select2-container")
    select2_container.first(".select2-selection").click

    first("input.select2-search__field").set(value)
    page.execute_script(%|$("#{scope} ~ input.select2-search__field:visible").keyup();|)
    body = find(:xpath, "//body")
    matches = body.find_all(".select2-results li", text: value)
    matches.last.click
  end

  # select2_ajax helper to make capybara work with ajax-enabled Select2 elements
  # assumes 'placeholder' option is used in Select2 (if it is using ajax, it should be)
  #
  # usage:
  #
  #    it "should have a select2 field for searching by team name" do
  #        @team = Factory :team
  #        select2_ajax @team.name, from: "Select a Team", minlength: 4
  #        click_button "Join"
  #        page.should have_content "You are now on '#{@team.name}'."
  #    end
  # Thx to https://gist.github.com/sbeam/3849340
  def select2_ajax(value, options = {})
    if !options.is_a?(Hash) || !options.key?(:from)
      raise "Must pass a hash containing 'from'"
    end

    placeholder = options[:from]
    minlength = options[:minlength] || 4

    # click_link placeholder

    page.find(:xpath, "//*[text()='#{placeholder}']").click

    js = %Q|container = $('.select2-container:contains("#{placeholder}")');
            $('input[type=text]', container).val('#{value[0, minlength]}').trigger('keyup');
            window.setTimeout( function() {
              $('li:contains("#{value}")', container).click();
            }, 5000);|
    page.execute_script(js)
  end
end
