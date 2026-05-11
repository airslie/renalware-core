module Renalware
  class ApplicationComponent < ViewComponent::Base
    include Pundit::Authorization
    include Pagy::Method

    include Rails.application.routes.url_helpers

    delegate :current_user, :inline_svg_tag, to: :helpers

    def hospitals
      Renalware::Hospitals::Engine.routes.url_helpers
    end
  end
end
