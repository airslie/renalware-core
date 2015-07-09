log '--------------------Adding EpisodeTypes--------------------'

EpisodeType.find_or_create_by!(term: "De novo", definition: "First infection.")
EpisodeType.find_or_create_by!(term: "Recurrent",
                               definition: "An episode that occurs within 4 weeks of completion of therapy of a prior episode but with a different organism.")
EpisodeType.find_or_create_by!(term: "Relapsing",
                               definition: " An episode that occurs within 4 weeks of completion of therapy of a prior episode with the same organism or 1 sterile episode.")
EpisodeType.find_or_create_by!(term: "Repeat",
                               definition: "An episode that occurs more than 4 weeks after completion of therapy of a prior episode with the same organism.")
EpisodeType.find_or_create_by!(term: "Refractory",
                               definition: "Failure of the effluent to clear after 5 days of appropriate antibiotics.")
EpisodeType.find_or_create_by!(term: "Catheter-related",
                               definition: "Peritonitis in conjunction with an exit-site or tunnel infection with the same organism or 1 site.")
EpisodeType.find_or_create_by!(term: "Other", definition: "Refer to notes.")
