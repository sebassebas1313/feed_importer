Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :feeds do
    collection do
      post 'import', to: 'feeds#import'
    end
  end
end
