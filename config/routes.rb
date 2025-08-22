Rails.application.routes.draw do
  get "companies/index"
  get "companies/show"
  get "companies/new"
  get "companies/create"
  get "companies/edit"
  get "companies/update"
  get "companies/destroy"

  resources :users, only: [:index, :show] do
    resources :tweets, only: [:index]
  end


  resources :tweets, only: [:index]

  get '/users/by_username/:username', to: 'users#by_username', as: :user_by_username


  post '/reports/generate', to: 'reports#generate'
end
