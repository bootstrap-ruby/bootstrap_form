Dummy::Application.routes.draw do
  resources :users

  root to: "bootstrap#form"
end
