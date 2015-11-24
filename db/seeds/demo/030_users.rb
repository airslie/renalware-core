module Renalware
 log '--------------------Adding Demo Site Users--------------------'

  sites = %w(Barts KCH Lister)

  sites.each do |site|
    sitecode = site.downcase
    #superadmin
    username = "super#{sitecode}"
      Renalware::User.find_or_create_by!(username: username) do |u|
        u.given_name = site
        u.family_name = 'Superuser'
        u.email = "#{username}@#{sitecode}.trust.uk"
        u.password = 'renalware'
        u.approved = true
        u.roles = [Renalware::Role.find_by!(name: :super_admin)]
        u.signature = "#{site} Superuser"
      end
    log "---#{username} created!"
    #admin
    username = "#{sitecode}admin"
      Renalware::User.find_or_create_by!(username: username) do |u|
        u.given_name = site
        u.family_name = 'Admin'
        u.email = "#{username}@#{sitecode}.trust.uk"
        u.password = 'renalware'
        u.approved = true
        u.roles = [Renalware::Role.find_by!(name: :admin)]
        u.signature = "#{site} Admin"
      end
    log "---#{username} created!"

    #clinician
    username = "#{sitecode}doc"
      Renalware::User.find_or_create_by!(username: username) do |u|
        u.given_name = 'Doctor'
        u.family_name = site
        u.email = "#{username}@#{sitecode}.trust.uk"
        u.password = 'renalware'
        u.approved = true
        u.roles = [Renalware::Role.find_by!(name: :clinician)]
        u.signature = "Dr #{site}"
      end
    log "---#{username} created!"

    #nurse NB same role as doc
    username = "#{sitecode}nurse"
      Renalware::User.find_or_create_by!(username: username) do |u|
        u.given_name = site
        u.family_name = 'Nurse'
        u.email = "#{username}@#{sitecode}.trust.uk"
        u.password = 'renalware'
        u.approved = true
        u.roles = [Renalware::Role.find_by!(name: :clinician)]
        u.signature = "#{site} Nurse"
      end
    log "---#{username} created!"

    #guest i.e. readonly
    username = "#{sitecode}guest"
      Renalware::User.find_or_create_by!(username: username) do |u|
        u.given_name = site
        u.family_name = 'Guest'
        u.email = "#{username}@#{sitecode}.trust.uk"
        u.password = 'renalware'
        u.approved = true
        u.roles = [Renalware::Role.find_by!(name: :read_only)]
        u.signature = "#{site} Guest"
      end
    log "---#{username} created!"
  end
end