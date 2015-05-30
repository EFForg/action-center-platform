Actioncenter::Application.routes.draw do
  get "robots.txt", controller: :robots, action: :show, format: 'text'

  resources :source_files, :only => [:index, :create, :destroy], :controller => 's3_uploads' do
    get :generate_key, :on => :collection
  end

  # Root - Redundant - TODO - refactor
  get "welcome/index"
  root 'welcome#index'


  # EFF TOOLS (Call, Share, Petition) - External Reusable Services

  post "tools/call"
  post "tools/petition"
  post "tools/tweet"
  post "tools/email"
  get "tools/email_target"
  get "tools/reps"
  get "tools/reps_raw"
  get "tools/social_buttons_count"
  
  get "smarty_streets/:action", controller: :smarty_streets
  get "petition/:id/recent_signatures", :to => "petition#recent_signatures", :format => 'json'

  # EFF Resources

  devise_for :users, path: '', path_names:  {sign_in:  'login',
                                             sign_out: 'logout',
                                             sign_up:  'register'},
                               controllers: {sessions: 'sessions'}
  resource :user, path: 'account', only: [:show, :edit, :update] do
    member do
      delete :clear_activity
    end
  end

  # override devise's user_root (defaults to site root)
  get 'account', to: 'users#show', as: 'user_root'

  resources :action_page, path: :action do
    member do
      get :embed_iframe
    end
    collection do
      get :embed
    end
  end
  resources :subscriptions, only: :create
  resources :partners, only: [:show, :edit, :update] do
    member do
      get :csv
      post 'users' => 'partners#add_user', as: :add_user
      delete 'users/:user_id' => 'partners#remove_user', as: :remove_user
    end
  end
  namespace :admin do
    get 'mailer/:action/:id' => 'mailer#:action'
    resources :petitions, only: :show do
      member do
        get :csv
        get '/:bioguide_id' => 'petitions#report'
      end
    end
    resources :email_campaigns, only: :none do
      member do
        get :date_tabulation
        get :congress_tabulation
        get 'staffer_report/:bioguide_id', to: 'email_campaigns#staffer_report', as: :staffer_report
      end
    end
    resources :em
    resources :partners, except: [:show, :edit, :update]
    resources :topic_categories, :topic_sets, :topics
    resources :action_pages do
      get :updated_at
      get :publish
      get :unpublish
      get :destroy
      post 'update_featured_pages', :on => :collection
      patch :preview
    end

    get "images", to: "images#index"
  end
end
