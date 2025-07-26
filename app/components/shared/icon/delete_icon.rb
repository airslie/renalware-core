# frozen_string_literal: true

class Shared::DeleteIcon < Shared::Base
  def initialize(path:, policy:)
    @path = path
    @policy = policy
    super()
  end

  def render?
    policy.destroy?
  end

  def view_template
    a(
      href: path,
      data: { method: :delete, confirm: "Are you sure?" }
    ) { Icon(:trash) }
  end

  private

  attr_reader :path, :policy
end
