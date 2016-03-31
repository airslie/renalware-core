module Renalware
  class UpdateUser

    attr_reader :delivery_method, :notifications, :notifier, :user

    def initialize(user)
      @user = user
      @notifier = Admin::UserMailer
      @notifications = []
      # TODO: Change this to `:deliver_later` once we have background workers configured.
      @delivery_method = :deliver_now
    end

    def call(params)
      update!(params) && notify!
    end

    private

    def update!(params)
      User.transaction do
        user.super_admin_update = true
        approve if can_approve?(params)
        unexpire if can_unexpire?(params)
        authorise(params[:roles] || [])
        user.save!
      end
    rescue ActiveRecord::RecordInvalid
      false
    end

    def notify!
      notifications.each { |n| n.public_send(delivery_method) } if notifications.any?
      true
    end

    def can_approve?(params)
      true?(params[:approved]) && !user.approved?
    end

    def approve
      notifications << notifier.approval(user)
      user.approved = true
    end

    def can_unexpire?(params)
      true?(params[:unexpire]) && user.expired?
    end

    def unexpire
      notifications << notifier.unexpiry(user)
      user.expired_at = nil
      user.last_activity_at = Time.zone.now
    end

    def authorise(roles)
      user.roles = roles
    end

    def true?(param)
      param == 'true'
    end
  end
end
