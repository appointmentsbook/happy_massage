module Admin
  class SessionsController < BaseController
    def logout
      CASClient::Frameworks::Rails::Filter.logout(self, admin_root_url)

      render nothing: true
    end
  end
end
