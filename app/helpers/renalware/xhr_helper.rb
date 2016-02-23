require_dependency "renalware"

module Renalware
  module XHRHelper
    def refresh(el, partial:, locals:)
      <<-EOS.squish.html_safe
        $("#{el}").html("#{escape_javascript(render partial, locals)}");
      EOS
    end
  end
end
