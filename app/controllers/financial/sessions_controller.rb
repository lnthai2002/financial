require_dependency "financial/application_controller"

module Financial
  class SessionsController < ApplicationController
    def logout
      reset_session
      CASClient::Frameworks::Rails::Filter.logout(self)
    end
  end
end
