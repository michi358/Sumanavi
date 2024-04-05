Rails.application.routes.draw do
  
  # エンドユーザー
  devise_for :users, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }
  
  scope module: :public do
    root to: 'homes#top'
    get '/about' => "homes#about", as: 'about'
    resources :posts
    resources :users, only:[:show, :edit, :update] do
      collection do
        get :unsubscribe
        patch :withdraw
      end
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
