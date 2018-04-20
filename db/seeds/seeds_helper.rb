# frozen_string_literal: true

module SeedsHelper
  def without_papertrail_versioning_for(klass)
    raise ArgumentError unless klass.is_a? Class
    klass.paper_trail.disable
    yield
    klass.paper_trail.enable
  end
end
