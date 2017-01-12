Rails.application.routes.draw do
  root 'fi_calc#timetofi'
  get '/glossary', to: 'fi_calc#glossary'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
