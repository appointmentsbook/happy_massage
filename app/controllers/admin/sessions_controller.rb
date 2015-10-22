module Admin
  class SessionsController < BaseController
    def logout
      CASClient::Frameworks::Rails::Filter.logout(self, admin_root_url)
    end
  end
end
