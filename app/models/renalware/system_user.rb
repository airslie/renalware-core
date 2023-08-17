# frozen_string_literal: true

module Renalware
  class SystemUser
    USERNAME = "systemuser"

    def self.username = USERNAME
    def self.find = User.find_by!(username: username)
  end
end
