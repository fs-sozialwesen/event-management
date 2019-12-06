Rails.application.routes.draw do

  get "buchung/:seminar_id", to: redirect { |params, _| "seminar-buchung/#{params[:seminar_id]}" }

  get  'seminar-buchung/:seminar_id',   to: 'bookings#new',    as: :booking_new
  post 'seminar-buchung',               to: 'bookings#create', as: :booking_create
  get  'buchungsnachricht/:booking_id', to: 'bookings#show',   as: :booking_show

  root to: 'pages#home'

  get 'seminare/start/:year',    to: redirect('https://www.pbw-lsa.de/fort_weiterbildung/seminare/')
  get 'seminare(/:category_id)', to: redirect('https://www.pbw-lsa.de/fort_weiterbildung/seminare/')
  get 'seminar/:id',             to: redirect { |params, _| "https://www.pbw-lsa.de/seminar/detail/#{params[:id]}/" }
  get 'seminar/detail/:id',      to: redirect { |params, _| "https://www.pbw-lsa.de/seminar/detail/#{params[:id]}/" }
  get 'suche',                   to: redirect('https://www.pbw-lsa.de/fort_weiterbildung/seminare/')

  devise_for :users, skip: [:registrations]
  as :user do
    get 'users/edit' => 'devise/registrations#edit',   as: 'edit_user_registration'
    patch 'users'    => 'devise/registrations#update', as: 'user_registration'
  end

  namespace :api, constraints: { format: 'json' } do
    root to: 'seminars#docs'
    resources(:categories, only: %i(index show)) { get :tree, on: :collection }
    resources :seminars,   only: %i(index show)
    resources :locations,  only: %i(index)
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
        get :date, :calendar, :canceled, :search, :filter, :recommended
        get 'editing_status(/:scope)', action: :editing_status, as: :editing_status
        get 'category(/:id)',          action: :category,       as: :category
      end
    end
    resources :legal_statistics, only: %i(index show update)
    resources(:categories, except: :edit) { put :move, on: :member }
    resources :bookings,   only: %i(show new create)
    resources :attendees,  only: %i(index show update) do
      get :cancel
      post :cancel, action: :destroy
      get :company, on: :collection
    end
    resources :invoices,  except: :edit
    resources :companies, except: :edit
    resources(:catalogs,  except: %i(edit destroy)) { get :make_current, on: :member }

    resources :feedbacks, only: %i(new create)
  end

  get 'agbs'          => 'static_pages#terms_of_service', as: :terms_of_service
  get 'datenschutz'   => 'static_pages#data_protection',  as: :data_protection
  get 'daten'         => 'static_pages#data_info',        as: :data_info
  get 'rabatt_system' => 'static_pages#reductions',       as: :reductions
  get 'zeichensetzen' => 'static_pages#zeichensetzen',    as: :zeichensetzen
end
