# frozen_string_literal: true

module Renalware
  log "Adding Demo Site Users\n" do
    sites = %w(Barts KCH Kent Lister)

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
        u.feature_flags = 2
        u.professional_position = Faker::Job.position
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
        u.professional_position = Faker::Job.position
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
        u.professional_position = Faker::Job.position
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
        u.professional_position = Faker::Job.position
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
        u.professional_position = [Faker::Job.seniority, Faker::Job.position].compact.join(" ")
      end

      log "#{username} created.", type: :sub
    end
    # add rwdev superadmin
    username = "rwdev"
    Renalware::User.find_or_create_by!(username: username) do |u|
      u.given_name = "Renalware"
      u.family_name = "Developer"
      u.email = "renalware@airslie.com"
      u.password = "develop!"
      u.approved = true
      u.roles = [Renalware::Role.find_by!(name: :devops)]
      u.signature = "Renalware Developer"
      u.professional_position = Faker::Job.position
    end
  end
end
