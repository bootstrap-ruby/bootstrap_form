Dummy::Application.routes.draw do
  get "fragment" => "bootstrap#fragment", as: :fragment
  resources :addresses
  resources :users

  root to: "bootstrap#form"
end
