# frozen_string_literal: true

require_dependency "renalware/letters"

module Renalware
  module Letters
    module Mailshots
      class MailshotsController < BaseController
        include Pagy::Backend

        def index
          pagy, mailshots = pagy(Mailshot.order(created_at: :desc))
          authorize mailshots
          render locals: { mailshots: mailshots, pagy: pagy }
        end

        def new
          mailshot = Mailshot.new
          authorize mailshot
          render_new(mailshot)
        end

        def create
          authorize Mailshot, :create?

          mailshot = create_mailshot
          if mailshot.valid?
            redirect_to letters_mailshots_path, notice: "Mailshot letters have been created"
          else
            render_new(mailshot)
          end
        end

        private

        def render_new(mailshot)
          render :new, locals: { mailshot: mailshot }
        end

        def mailshot_params
          params
            .require(:mailshot)
            .permit(
              :letterhead_id, :description, :author_id, :body, :sql_view_name
            )
        end

        # TODO: tidy up proof of concept code!
        # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
        def create_mailshot
          Mailshot.transaction do
            # 1 Save the mailshot
            mailshot = Mailshot.new(mailshot_params)

            return mailshot unless mailshot.save_by(current_user)

            mailshot.update!(letters_count: mailshot.recipient_patients.length)

            main_recipient_attributes = ActionController::Parameters.new(
              {
                main_recipient_attributes: {
                  person_role: :patient,
                  id: nil,
                  addressee_id: nil
                }
              }).permit(main_recipient_attributes: [:person_role, :id, :addressee_id])

            attributes = mailshot_params.slice(
              :letterhead_id, :author_id, :body, :description
            ).merge(issued_on: Time.zone.now).merge(main_recipient_attributes)

            # 2 create the letters, passing through the 'state machine'
            mailshot.recipient_patients.each do |pat|
              # State 1: Draft
              letter = LetterFactory.new(pat, attributes).build
              # letter.main_recipient = nil # Stop GP being set as main recipient
              # letter.build_main_recipient(person_role: :patient)
              letter.save_by!(current_user)

              # State 2: Pending Review
              letter.submit(by: current_user) # now pending review
              letter.save!
              letter = Letters::Letter::PendingReview.find(letter.id)

              # State 3: Approved - after which it can be printed
              ApproveLetter
                .build(letter)
                .broadcasting_to_configured_subscribers
                .call(by: current_user)

              mailshot.items.create!(letter: letter)
            end
            mailshot
          end
          # rubocop:enable Metrics/MethodLength, Metrics/AbcSize
        end
      end
    end
  end
end
