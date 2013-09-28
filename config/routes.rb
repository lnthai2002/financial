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
  resources :reports

  get 'recurring_payment_categories', :to=>'recurring_payments#reload_categories', :as=>:recurring_payment_reload_categories

  match 'expenses/:year/:month' => 'expenses#index', :defaults=>{:year=>nil,:month=>nil}, :conditions=>{:method=>:get}

  root :to => 'plans#index'
end
