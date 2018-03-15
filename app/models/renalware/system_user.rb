# frozen_string_literal: true

module Renalware
  class SystemUser
    USERNAME = "systemuser".freeze

    def self.username
      USERNAME
    end

    def self.find
      User.find_by!(username: username)
    end
  end
end
