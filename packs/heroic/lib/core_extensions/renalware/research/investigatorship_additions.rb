# frozen_string_literal: true

require "renalware"

#
# The Heroic custom Investigatorship::Document class has roles[] attribute that is an array of enums
# A quirk of simple_form is that, at least when using select2 mutiple, which we are in the
# HTML form in question, it always posts a blank "" option as well as the other chosen options.
# This "" option causes Enumerize's validation to complain that it is not a valid enum.
# To get around this without muddying renalware-core with our particular data-cleaning requirements,
# we use module prepend to insert a before action into the controller to remove blank items from the
# array. This is yet another way to extend renalware-core - usually as a last resort, as it is still
# monkey patching even it is using the more exeptable modul#prepend - which incidentally has the
# advantage that super can be called.
#
module InvestigatorshipAdditions
  def included(_module)
    before_action :remove_unwanted_blank_options_submitted_by_select2_multiple
  end

  def remove_unwanted_blank_options_submitted_by_select2_multiple
    params.dig(:investigatorship, :document, :roles)&.reject!(&:blank?)
  end
end

ActiveSupport::Reloader.to_prepare do
  Renalware::Research::InvestigatorshipsController.prepend InvestigatorshipAdditions
end
