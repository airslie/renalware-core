module Renalware
  log "Adding Peritonitis Episode Types" do

    PD::EpisodeType.find_or_create_by!(
      term: "De novo",
      definition: "First infection."
    )

    PD::EpisodeType.find_or_create_by!(
      term: "Recurrent",
      definition: <<-DEF.squish
        An episode that occurs within 4 weeks of completion of therapy of a prior
        episode but with a different organism.
      DEF
    )

    PD::EpisodeType.find_or_create_by!(
      term: "Relapsing",
      definition: <<-DEF.squish
        An episode that occurs within 4 weeks of completion of therapy of a prior
        episode with the same organism or 1 sterile episode
      DEF
    )

    PD::EpisodeType.find_or_create_by!(
      term: "Repeat",
      definition: <<-DEF
        An episode that occurs more than 4 weeks after completion of
        therapy of a prior episode with the same organism.
      DEF
    )

    PD::EpisodeType.find_or_create_by!(
      term: "Refractory",
      definition: <<-DEF
        Failure of the effluent to clear after 5 days of appropriate antibiotics.
      DEF
    )

    PD::EpisodeType.find_or_create_by!(
      term: "Catheter-related",
      definition: <<-DEF
        Peritonitis in conjunction with an exit-site or tunnel infection with
        the same organism or 1 site.
      DEF
    )

    PD::EpisodeType.find_or_create_by!(
      term: "Other",
      definition: "Refer to notes."
    )
  end
end
