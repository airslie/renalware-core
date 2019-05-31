# frozen_string_literal: true

require_dependency "renalware/patients"

module Renalware
  module Patients
    class SyncPracticesViaApi
      def call
        # Fetch each page of organisations from the API
        client.fetch_pages(roles: roles, last_change_date: nil) do |page|
          # For each organisation in the page..
          page.items.each do |item|
            next if item.last_change_date.blank?

            practice = add_or_update_practice(item)
            soft_delete_practice(practice) if practice.present? && item.status != "Active"
            log flush: true
          end
        end
      end

      private

      # Returns the added or updated practice
      def add_or_update_practice(item)
        last_synced_at = practice_sync_dates[item.org_id]
        item_already_in_rw = last_synced_at.present?
        last_change_date = Date.parse(item.last_change_date)
        log "%-6s %-10s %-2s ", item.org_id, item.status, item_already_in_rw ? "RW" : ""
        practice = nil
        if item_already_in_rw
          if last_change_date > last_synced_at
            practice = update_existing_practice(item)
          end
        else
          practice = add_practice(item)
        end
        practice
      end

      def add_practice(item)
        log "Adding "
        practice = Renalware::Patients::Practice.new
        practice.build_address
        save_practice_changes(practice, item)
      end

      def update_existing_practice(item)
        log "Updating "
        practice = find_practice_with_code(item.org_id)
        save_practice_changes(practice, item)
      end

      def log(*args, flush: false)
        print sprintf(*args) if args.any?
        puts "" if flush
      end

      def find_practice_with_code(code)
        Renalware::Patients::Practice.with_deleted.find_by!(code: code)
      end

      def save_practice_changes(practice, item)
        practice.assign_attributes(
          code: item.org_id,
          name: item.name,
          telephone: item.details.tel,
          updated_at: Time.zone.now # unless we do this, updated_at won't update if no changes
        )
        build_practice_address(practice.address, item)
        practice.save!
        practice
      end

      def build_practice_address(address, item)
        details = item.details
        address.assign_attributes(
          street_1: details.addr_ln1,
          street_2: details.addr_ln2,
          street_3: details.addr_ln3,
          town: details.town,
          county: details.county,
          postcode: details.post_code,
          country_id: uk_country_id,
          region: details.country
        )
        address
      end

      # Soft delete the practice unless its status is Active?
      def soft_delete_practice(practice)
        log "Deleting "
        practice.destroy
      end

      def client
        @client ||= NHSApiClient::Organisations::Client.new
      end

      def roles
        %i(practices) # also e.g. branch_surgeries
      end

      def uk_country_id
        @uk_country_id ||= Renalware::System::Country.find_by!(alpha2: "GB").id
      end

      def practice_sync_dates
        @practice_sync_dates ||= begin
          Renalware::Patients::Practice.with_deleted.pluck(:code, :updated_at).to_h
        end
      end
    end
  end
end
