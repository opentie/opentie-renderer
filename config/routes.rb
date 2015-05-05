Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'dashboard#index'

  get :dashboard, controller: 'dashboard', action: :index

  get :login, controller: 'sessions', action: :new
  post :login, controller: 'sessions', action: :create
  get :logout, controller: 'sessions', action: :edit
  post :logout, controller: 'sessions', action: :destroy

  resources :projects,
    only: [:show, :edit, :new, :create] do

    resources :request_schemata,
      controller: 'projects/request_schemata',
      only: [:show, :index] do

      resource :request,
        controller: 'projects/request_schemata/request',
        only: [:show, :edit, :update, :destroy]
    end

    resources :invitations,
      controller: 'projects/invitations',
      only: [:new, :index]
  end

  resources :divisions,
    only: [:show] do

    resources :request_schemata,
      controller: 'divisions/request_schemata',
      only: [:show, :index] do

      resources :requests,
        controller: 'divisions/request_schemata/requests',
        only: [:index, :show]
    end

    resources :project_histories,
      controller: 'divisions/project_histories',
      only: [:index]

    resources :projects,
      controller: 'divisions/projects',
      only: [:index, :show] do

      resources :requests,
        controller: 'divisions/projects/requests',
        only: [:index, :show]
    end
  end
end
