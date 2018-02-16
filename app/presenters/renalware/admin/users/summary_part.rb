module Renalware
  module Admin
    module Users
      class SummaryPart < Renalware::SummaryPart
        def to_partial_path
          "renalware/admin/users/summary_part"
        end

        def users_needing_approval_count
          @users_needing_approval_count ||= User.unapproved.count
        end

        def users_needing_approval_title
          [
            users_needing_approval_count,
            "user".pluralize(users_needing_approval_count),
            "awaiting approval"
          ].join(" ")
        end
      end
    end
  end
end
