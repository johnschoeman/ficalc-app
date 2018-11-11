Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'fi_calc#timetofi'
  get '/glossary', to: 'fi_calc#glossary'
  get '/about',    to: 'fi_calc#about'
  get '/contact',  to: 'fi_calc#contact'
end
