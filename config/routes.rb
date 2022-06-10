Rails.application.routes.draw do
  resources :applications, param: :token, only: [:create, :update, :destroy] do
    get '/', to: 'applications#show'
    resources :chats, param: :number, only: [:index, :create, :update, :destroy] do
      resources :messages, only: [:index, :create]
    end
  end
end
