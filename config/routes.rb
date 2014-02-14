Financial::Engine.routes.draw do
  resources :categories
  resources :expenses do
    member do
      get :breakdown
    end
  end
  resources :finances
  resources :incomes
  resources :investments
  resources :mortgage_adjs
  resources :payment_types
  resources :people
  resources :plans
  resources :recurring_payments do
    member do
      patch :terminate
    end
  end
  resources :reports do
    collection do
      get :balance_by_months
      get :summaries
      get :monthly_for_categories, :action=>:monthly_for_categories_form
      post :monthly_for_categories, :action=>:monthly_for_categories
      get :date_summary
      get :month_summary
      get :week_summary
    end
  end
  resource :search do
    get :payments, :action=>:payments_search_form
    post :payments, :action=>:payments
  end
  delete 'logout', to: 'sessions#logout'
  get 'recurring_payment_categories', :to=>'recurring_payments#reload_categories', :as=>:recurring_payment_reload_categories

  root :to => 'expenses#new'
end
