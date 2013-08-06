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
  resources :recurring_payments

  match 'expenses/:year/:month' => 'expenses#index', :defaults=>{:year=>nil,:month=>nil}, :conditions=>{:method=>:get}

  root :to => 'plans#index'
end
