Rails.application.routes.draw do

  get  'buchung/:seminar_id',   to: 'buchung#new',    as: :buchung_new
  post 'buchung',               to: 'buchung#create', as: :buchung_create
  get  'nachricht/:booking_id', to: 'buchung#show',   as: :buchung_show

  # root to: 'pages#home'

  get 'seminare/start/:year',            to: 'seminare#home',   as: :seminare_home
  get 'seminare(/:year(/:category_id))', to: 'seminare#index',  as: :seminare_visitor
  get 'seminar/:id',                     to: 'seminare#show',   as: :seminar_visitor
  get 'suche',                           to: 'seminare#search', as: :seminar_search

  devise_for :users, skip: [:registrations]
  as :user do
    get 'users/edit' => 'devise/registrations#edit',   as: 'edit_user_registration'
    patch 'users'    => 'devise/registrations#update', as: 'user_registration'
  end

  namespace :api, constraints: { format: 'json' } do
    resources :categories, only: [:index] { get :tree, on: :collection }
    resources :seminars, only: %i(index show)
  end

  namespace :admin do

    root to: 'dashboard#show'

    get 'search', to: 'search#index', as: :search

    resources(:users,     except: :edit) do
      get :access_rights, on: :collection
      get :seminars,      on: :member
    end
    resources :locations, except: :edit
    resources(:teachers,  except: :edit) { get :seminars, on: :member }

    resources :seminars do
      member do
        get :attendees, :pras, :versions
        patch :toggle_category, :publish, :unpublish, :finish_editing, :finish_layout
      end
      collection do
        get :date, :calendar, :canceled
        get 'editing_status(/:scope)', action: :editing_status, as: :editing_status
        get 'category(/:id)',          action: :category,       as: :category
        get :search
        get :filter
      end
    end
    resources :legal_statistics, only: %i[index show update]
    resources :categories, except: :edit do
      put :move, on: :member
    end
    resources :bookings,   only: %i[show new create]
    resources :attendees,  only: %i[index show update] do
      get :cancel
      post :cancel, action: :destroy
      get :company, on: :collection
    end
    resources :invoices,  except: :edit
    resources :companies, except: :edit
    resources(:catalogs,  except: %i[edit destroy]) { get :make_current, on: :member }

    resources :feedbacks, only: %i[new create]
  end

  get 'agbs'          => 'static_pages#terms_of_service', as: :terms_of_service
  get 'datenschutz'   => 'static_pages#data_protection',  as: :data_protection
  get 'daten'         => 'static_pages#data_info',        as: :data_info
  get 'rabatt_system' => 'static_pages#reductions',       as: :reductions

  mount Alchemy::Engine => '/'
  # get ':path1(/:path2(/:path3))' => 'pages#show', as: :pages
end
