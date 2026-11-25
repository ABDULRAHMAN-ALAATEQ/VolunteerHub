Rails.application.routes.draw do
  root 'portal#index'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  resources :opportunities, only: [:index, :show, :new, :create, :edit, :update] do
    post :register, on: :member
  end
  post 'registrations/:id/submit_hours', to: 'registrations#submit_hours', as: :submit_hours
  patch 'registrations/:id/review', to: 'registrations#review', as: :review_registration
  post 'registrations/:id/certificate', to: 'registrations#issue', as: :issue_certificate
  resources :certificates, only: [:show]
end
