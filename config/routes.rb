Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "fi_calc#timetofi"

  resources :passwords, controller: "clearance/passwords", only: %i[create new]
  resource :session, controller: "clearance/sessions", only: %i[create]
  resources :users, controller: "clearance/users", only: %i[create] do
    resource :password,
             controller: "clearance/passwords", only: %i[create edit update]
  end

  get "/sign_in" => "clearance/sessions#new", as: "sign_in"
  delete "/sign_out" => "clearance/sessions#destroy", as: "sign_out"
  get "/sign_up" => "clearance/users#new", as: "sign_up"

  resources :financial_data

  resources :imports, only: %i[create]

  get "/glossary", to: "fi_calc#glossary"
  get "/about", to: "fi_calc#about"
  get "/contact", to: "fi_calc#contact"
end
