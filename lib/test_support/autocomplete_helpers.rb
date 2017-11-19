module AutocompleteHelpers
  def fill_autocomplete(form, field, options = {})
    fill_in field, with: options[:with]

    page.execute_script " $('#{form}').find('[name=#{field}]').trigger('focus') "
    page.execute_script " $('#{form}').find('[name=#{field}]').trigger('keydown') "
    selector = %Q{ul.ui-autocomplete li.ui-menu-item:contains("#{options[:select]}")}

    expect(page).to have_selector("ul.ui-autocomplete li.ui-menu-item")
    page.execute_script " $('#{selector}').trigger('mouseenter').click() "
  end
end
