# frozen_string_literal: true

require_dependency "renalware"

module Renalware
  module Users
    class UsersController < BaseController
      include Pagy::Backend

      def index
        query = params.fetch(:q, {})
        query[:s] ||= "family_name"
        search = User
          .includes(:roles)
          .where.not(username: [:rwdev, :systemuser])
          .where(hidden: false)
          .ransack(query)
        pagy, users = pagy(search.result(distinct: true))
        authorize users
        render locals: { users: users, pagy: pagy, user_search: search }
      end
    end
  end
end
