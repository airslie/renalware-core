# frozen_string_literal: true

module SeedsHelper
  def without_papertrail_versioning_for(klasses)
    Array(klasses).each { |klass| klass.paper_trail.disable }
    yield
    Array(klasses).each { |klass| klass.paper_trail.enable }
  end
end
