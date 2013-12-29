module Financial
  class ApplicationController < ActionController::Base
    before_filter CASClient::Frameworks::Rails::Filter
    before_filter :check_user_finance

    layout 'financial/layouts/application'

    protected

    #Make sure all user entering finance module must have Finance
    def check_user_finance
      @person = Person.where(:email=>session[:cas_user]).first
      if @person.finance.blank?
        redirect_to new_finance_path
      end
    end
  end
end
