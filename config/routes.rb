Financial::Engine.routes.draw do
  resources :plans
  resources :investments
  resources :mortgage_adjustments
  resources :people
  resources :finances

  resources :payment_types

  match 'expenses/:year/:month' => 'expenses#index', :defaults=>{:year=>nil,:month=>nil}, :conditions=>{:method=>:get}
  resources :exp_types

  resources :expenses do
    member do
      get :breakdown
    end
  end

  root :to => 'plans#index'
end
