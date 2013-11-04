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
  resources :mortgage_adjustments
  resources :payment_types
  resources :people
  resources :plans
  resources :recurring_payments do
    member do
      put :terminate
    end
  end
  resources :reports do
    collection do
      get :by_category
      get :for_category
      get :by_date
      get :by_month
      get :by_week
    end
  end

  get 'recurring_payment_categories', :to=>'recurring_payments#reload_categories', :as=>:recurring_payment_reload_categories

  root :to => 'expenses#new'
end
