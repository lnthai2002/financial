require_dependency "financial/application_controller"

module Financial
  class SearchesController < ApplicationController
    def payments
      search = Search.new(params['search'])
      @results = search.execute
    end

    private

    def search_params
      #params.require(:search).permit(:net_monthly_income, :net_monthly_expense)
    end
  end
end
