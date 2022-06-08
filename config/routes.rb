Rails.application.routes.draw do
  get 'applications/:token', to: 'applications#show'
  resources :applications, param: :token, only: [:create, :update, :destroy]
end
