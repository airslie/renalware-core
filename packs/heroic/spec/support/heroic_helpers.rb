# frozen_string_literal: true

module HeroicHelpers
  def make_user_an_investigator(user:, manager: false)
    create(
      :research_investigatorship,
      user: user,
      study: study,
      manager: manager
    )
  end
end
