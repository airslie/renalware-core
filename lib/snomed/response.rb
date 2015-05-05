module Snomed
  class Response < OpenStruct
    def results
      self.matches
    end

    def total
      return details['total'] if details.present?
      return matches.size if matches.present?
      0
    end
  end
end
