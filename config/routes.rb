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
    get '/genre/search' => 'searches#genre_search'
    resources :posts do
      resources :post_comments, only: [:create, :destroy]
    end
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
    root to: "homes#top"
    get 'genre/search' => 'searches#genre_search'
    resources :users, only: [:index, :show, :update]
    resources :posts, only: [:index, :show, :destroy] do
      resources :post_comments, only: [:destroy]
    end
    resources :genres, only: [:index, :create, :update]
    # 投稿記事とgenreをアソシエーションしているため、エラー回避のためにdestroyは追加しない
  end

end
