# frozen_string_literal: true

# Override SessionPresenter methods where necessary in order
# to tailor output for the Protocol PDF.
module Renalware
  module HD
    module Protocol
      class SessionPresenter < HD::SessionPresenter
        def performed_on
          ::I18n.l(session.performed_on)
        end
      end
    end
  end
end
