Rocketstart::Application.routes.draw do

  root :to => "general#index"

  get "/login" => "session#new"
  match 'logout' => 'session#destroy'

  resource :session, :controller => :session, :only => [:create, :destroy]
  resource :remined, :only => [:new, :create, :edit, :update], :controller => 'users/remined'
  resource :entry, :controller => :entry do
    collection { get(:complete) }
  end

  #userに関する関する責務
  resources :users
  namespace :users do
    resource :entry, :controller => :entry, :only => [:new, :create] do
      collection { get(:complete) }
    end

    resource :email, :controller => :email, :only => [:new, :create] do
      collection do 
        get :complete
        get :send_complete
      end
    end
    match "/register/emailchange/:code" => "email#update", :as => "email_change", :via => :put
    match "/register/emailchange/:code" => "email#edit", :as => "email_change"

    resource :register, :only => [:new, :create, :update], :controller => 'register'
    match "/register/remined/:token" => "register#remined", :as => :register_remined_with_token
    match "/register/new/:code" => "register#new", :as => "register_with_token"

    resources :invitation, :only => [:new, :create]
    namespace :invitation do
      resource :register, :only => [:new, :create], :controller => "register" do
        collection { get(:complete) }
      end
      match "register/new/:code" => "register#new", :as => :register_invitation_with_token
    end

  end

  resource :dashboard, :controller => :dashboard, :only => [:show]

end
