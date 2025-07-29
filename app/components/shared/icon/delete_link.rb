# frozen_string_literal: true

class Shared::DeleteLink < Shared::Base
  def initialize(path:, policy: nil)
    @path = path
    @policy = policy
    super()
  end

  def render?
    policy.nil? || policy.destroy?
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
