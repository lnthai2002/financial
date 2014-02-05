module Financial
  class SearchesController < AuthorizableController
    def payments
      search = Search.new(params['search'], current_ability)
      @results = search.execute
    end
  end
end
