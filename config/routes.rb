Rails.application.routes.draw do

  devise_for :users,skip: [:passwords], controllers: {
  registrations: "public/registrations",
  sessions: 'public/sessions'
  }

  devise_for :admin,  skip: [:registrations, :passwords] ,controllers: {
  sessions: "admin/sessions"
  }

  namespace :admin do
    resources :customers, only: [:index, :show, :edit, :update]
    # home
    root to: 'homes#top'
  end

  scope module: :public do
    resources :users, only: [:show, :edit, :update, :index]
    resources :posts do
    resource :favorites, only: [:create, :destroy]
    end
    
    get "search" => "searches#search" , as:'search'
    root to: 'homes#top'
    get 'about' => 'homes#about'
  end

end
