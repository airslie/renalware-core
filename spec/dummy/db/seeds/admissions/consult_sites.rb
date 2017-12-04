module Renalware
  log "Creating Admission::ConsultSites" do
    %w(SiteA SiteB SiteC).each do |name|
      Admissions::ConsultSite.find_or_create_by!(name: name)
    end
  end
end
