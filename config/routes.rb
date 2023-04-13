Rails.application.routes.draw do

  devise_for :users,skip: [:passwords], controllers: {
  registrations: "public/registrations",
  sessions: 'public/sessions'
  }

  devise_for :admin,  skip: [:registrations, :passwords] ,controllers: {
  sessions: "admin/sessions"
  }

  namespace :admin do
    resources :users, only: [:index, :show, :edit, :update]
    # home
    root to: 'homes#top'
  end

  scope module: :public do
    resources :users, only: [:show, :edit, :update, :index]
    resources :posts
    
    get "search" => "searches#search" , as:'search'
    get "search_tag"=>"posts#search_tag"
    root to: 'homes#top'
    get 'about' => 'homes#about'
  end

end
