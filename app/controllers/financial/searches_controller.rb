module Financial
  class SearchesController < AuthorizableController
    #AJAX GET
    def payments_search_form
      respond_to do |format|
        format.js { render 'payments_search_form' }
      end
    end

    def payments
      search = Search.new(params['search'], current_ability)
      @results = search.execute
    end
  end
end
