module Panel
  class BaseController < ApplicationController
    layout 'panel'

    before_action :authentication, :authorization

    helper_method :current_user
    attr_reader :current_user

    def authentication
      CASClient::Frameworks::Rails::Filter.filter(self)
    end

    def authorization
      return if session[:cas_user].nil?

      if employee?
        @current_user = User.retrieve_from(user_session)
      else
        CASClient::Frameworks::Rails::Filter.logout(self, root_url)
      end
    end

    private

    def user_session
      @user_session ||= Sessions::UserSession.new(session)
    end

    def employee?
      user_session.employee?
    end
  end
end
