module Panel
  class SessionsController < BaseController
    def logout
      CASClient::Frameworks::Rails::Filter.logout(self, root_url)

      render nothing: true
    end
  end
end
