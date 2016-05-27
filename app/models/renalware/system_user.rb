module Renalware
  class SystemUser
    USERNAME = "systemuser"

    def self.username
      USERNAME
    end

    def self.find
      User.find_by!(username: username)
    end
  end
end
