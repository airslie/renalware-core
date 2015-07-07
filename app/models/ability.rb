class Ability
  include CanCan::Ability

  def initialize(user)
    define_permissions(user)
  end

  private

  def define_permissions(user)
    Permission.all.each do |permission|
      if user.has_role?(permission.role)
        can permission.ability, permission.models
      end
    end
  end
end
