# frozen_string_literal: true

require_dependency "renalware/letters"
require "collection_presenter"

module Renalware
  module Letters
    class ElectronicReceiptsController < BaseController
      include Renalware::Concerns::Pageable
      skip_after_action :verify_policy_scoped

      # PATCH
      def mark_as_read
        authorize receipt
        receipt.update(read_at: Time.zone.now)
        render locals: {
          receipt: ElectronicReceiptPresenter.new(receipt),
          layout: false
        }
      end

      # GET all unread electronic CCs
      def unread
        render_receipts(received_receipts.unread)
      end

      # GET all read electronic CCs
      def read
        render_receipts(received_receipts.read)
      end

      # GET all electronic CCs sent by the current user
      def sent
        render_receipts(sent_receipts)
      end

      private

      def render_receipts(receipts)
        patient_filter = Patients::SearchFilter.new(search_term, request)
        receipts = receipts.joins(letter: [:patient])
        receipts = patient_filter.call(receipts).ordered.page(page).per(per_page)
        authorize receipts

        render locals: {
          receipts: present_receipts(receipts),
          search_form: patient_filter.search_form
        }
      end

      def build_search_form_object
        Patients::SearchForm.new(
          term: search_term,
          url: request.path
        )
      end

      def search_term
        params.fetch(:patient_search, {}).fetch(:term, nil)
      end

      def receipt
        ElectronicReceipt.find_by!(letter_id: params[:letter_id], id: params[:id])
      end

      def received_receipts
        ElectronicReceipt.where(recipient_id: current_user.id)
      end

      def sent_receipts
        ElectronicReceipt.sent_by(current_user.id)
      end

      def present_receipts(receipts)
        CollectionPresenter.new(receipts, ElectronicReceiptPresenter)
      end
    end
  end
end
