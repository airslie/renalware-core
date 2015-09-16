module Renalware
  class Admin::UserMailer < ActionMailer::Base
    default from: 'renalware-admin@renalware.herokuapp.com'

    def approval(user)
      @user = user
      mail(to: @user.email, subject: 'Renalware account approved')
    end

    def unexpiry(user)
      @user = user
      mail(to: @user.email, subject: 'Renalware account reactivated')
    end
  end
end