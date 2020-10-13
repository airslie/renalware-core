# frozen_string_literal: true

require_dependency "renalware"

# Note we rely on template inheritance with this MDM Base class i.e. subclasses (e.g.
# HD::MDMPatientsController) can override templates and partials (e.g. add a _filters partial
# or override the _patient partial to replace what is displayed in the table).
# Otherwise the default template location is of course app/views/renalware/mdm_patients.
module Renalware
  class UsersController < BaseController
    include Pagy::Backend

    def index
      query = params.fetch(:q, {})
      query[:s] ||= "family_name"
      search = User
        .includes(:roles)
        .where.not(username: [:rwdev, :systemuser])
        .ransack(query)
      pagy, users = pagy(search.result(distinct: true))
      authorize users
      render locals: { users: users, pagy: pagy, user_search: search }
    end
  end
end
