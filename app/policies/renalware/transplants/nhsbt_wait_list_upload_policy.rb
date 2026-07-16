module Renalware
  module Transplants
    class NHSBTWaitListUploadPolicy < BasePolicy
      def new? = user_is_any_admin?
      def create? = new?
      def show? = new?
      def import? = new?
    end
  end
end
