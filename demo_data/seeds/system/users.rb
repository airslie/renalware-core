# frozen_string_literal: true

module Renalware
  log "Adding Demo Site Users\n" do
    sites = %w(Barts KCH Kent Lister)
    default_hospital_centre = Hospitals::Centre.find_by!(code: "QC001")

    # add rwdev superadmin
    username = "rwdev"
    Renalware::User.find_or_create_by!(username: username) do |u|
      u.given_name = "Renalware"
      u.family_name = "Developer"
      u.email = "renalware@airslie.com"
      u.password = "develop!"
      u.approved = true
      u.roles = [Renalware::Role.find_by!(name: :super_admin)]
      u.signature = "Renalware Developer"
      u.hospital_centre = default_hospital_centre
    end

    sites.each do |site|
      site_code = site.downcase

      # superadmin
      username = "super#{site_code}"
      Renalware::User.find_or_create_by!(username: username) do |u|
        u.given_name = site
        u.family_name = "Superuser"
        u.email = "#{username}@#{site_code}.trust.uk"
        u.password = "renalware"
        u.approved = true
        u.roles = [Renalware::Role.find_by!(name: :super_admin)]
        u.signature = "#{site} Superuser"
        u.hospital_centre = default_hospital_centre
      end

      log "#{username} created.", type: :sub

      # admin
      username = "#{site_code}admin"
      Renalware::User.find_or_create_by!(username: username) do |u|
        u.given_name = site
        u.family_name = "Admin"
        u.email = "#{username}@#{site_code}.trust.uk"
        u.password = "renalware"
        u.approved = true
        u.roles = [Renalware::Role.find_by!(name: :admin)]
        u.signature = "Dr #{site} Admin, MRCP"
        u.hospital_centre = default_hospital_centre
      end

      log "#{username} created.", type: :sub

      # clinician
      username = "#{site_code}doc"
      Renalware::User.find_or_create_by!(username: username) do |u|
        u.given_name = "Doctor"
        u.family_name = site
        u.email = "#{username}@#{site_code}.trust.uk"
        u.password = "renalware"
        u.approved = true
        u.roles = [Renalware::Role.find_by!(name: :clinical)]
        u.signature = "Dr #{site}"
        u.telephone = Faker::PhoneNumber.phone_number
        u.hospital_centre = default_hospital_centre
      end

      log "#{username} created.", type: :sub

      # nurse NB same role as doc
      username = "#{site_code}nurse"
      Renalware::User.find_or_create_by!(username: username) do |u|
        u.given_name = site
        u.family_name = "Nurse"
        u.email = "#{username}@#{site_code}.trust.uk"
        u.password = "renalware"
        u.approved = true
        u.roles = [Renalware::Role.find_by!(name: :clinical)]
        u.signature = "#{site} Nurse"
        u.hospital_centre = default_hospital_centre
      end

      log "#{username} created.", type: :sub

      # guest i.e. readonly
      username = "#{site_code}guest"
      Renalware::User.find_or_create_by!(username: username) do |u|
        u.given_name = site
        u.family_name = "Guest"
        u.email = "#{username}@#{site_code}.trust.uk"
        u.password = "renalware"
        u.approved = true
        u.roles = [Renalware::Role.find_by!(name: :read_only)]
        u.signature = "#{site} Guest"
        u.hospital_centre = default_hospital_centre
      end

      log "#{username} created.", type: :sub
    end
  end
end
