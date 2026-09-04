module Renalware
  module Heidi
    LaunchClinicVisitSessionResult = Struct.new(
      :success,
      :session,
      :heidi_result,
      :error,
      :link_account_url
    ) do
      alias_method :success?, :success

      def failed? = !success?
      def account_link_required? = link_account_url.present?
    end
  end
end
