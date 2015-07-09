log '--------------------Adding FluidDescriptions--------------------'

FluidDescription.find_or_create_by!(description: "Clear")
FluidDescription.find_or_create_by!(description: "Misty")
FluidDescription.find_or_create_by!(description: "Cloudy")
FluidDescription.find_or_create_by!(description: "Pea Soup")
