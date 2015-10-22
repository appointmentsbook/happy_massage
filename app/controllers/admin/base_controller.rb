module Admin
  class BaseController < ApplicationController
    layout 'admin'

    before_action :authentication, :authorization

    helper_method :current_admin_user
    attr_reader :current_admin_user

    def authentication
      CASClient::Frameworks::Rails::Filter.filter(self)
    end

    def authorization
      return if session[:cas_user].nil?

      if admin?
        @current_admin_user = admin_user_session
      else
        CASClient::Frameworks::Rails::Filter.logout(self, root_url)
      end
    end

    private

    def admin_user_session
      @admin_user_session ||= Sessions::AdminUserSession.new(session)
    end

    def admin?
      admin_user_session.admin?
    end
  end
end
