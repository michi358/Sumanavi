Rails.application.routes.draw do

  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
  sessions: "admin/sessions"
}
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

   # ゲストログイン
  devise_scope :user do
    post 'users/guest_sign_in', to: 'public/sessions#guest_sign_in'
  end

  namespace :admin do
    resources :users, only: [:index, :show, :update]
  end

end
