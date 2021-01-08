Rails.application.routes.draw do
  resources :exchanges

  scope module: :api do
    scope module: :v1 do
      post :trade_validate, to: 'trades#trade_validate'
    end
  end
end
