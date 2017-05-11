Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'top#index'
  delete 'top/hide/:track_id' => 'top#hide', as: :top_hide

  resources :goods, only: [:index]

  resources :users, only: [:index] do
    get 'playlists'
    get 'playlist/:id' => 'users#playlist', as: :playlist
    get 'playall'
    collection do
      post 'playlist/:id/good_toggle' => 'users#playlist_good_toggle', as: :playlist_good_toggle
    end
  end

  resources :playlists do
    resources :track, only: [:index, :create, :destroy]
    member do
      get  'search'
      get  'search_pager'
      post 'fork'
      get  'tracks'
    end
    collection do
      get 'all'
      get 'recent'
      get 'popular'
    end
  end

  # For OmniAuth
  get "/auth/:provider/callback" => "sessions#callback"
  get "/auth/failure"            => "sessions#failure"
  get "/logout"                  => "sessions#destroy", as: :logout
end
