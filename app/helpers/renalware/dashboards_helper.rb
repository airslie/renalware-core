module Renalware
  module DashboardsHelper
    def composed_dashboard_title(user_name)
      capture do
        concat content_tag(:span, I18n.t("renalware.dashboard.dashboards.title"))
        concat content_tag(:span, user_name, class: "dashboard-owner")
      end
    end
  end
end
