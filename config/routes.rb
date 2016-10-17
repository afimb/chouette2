ChouetteIhm::Application.routes.draw do

  devise_for :users, :controllers => {
    :registrations => 'users/registrations', :invitations => 'users/invitations'
  }

  devise_scope :user do
    authenticated :user do
      root :to => 'referentials#index', as: :authenticated_root
    end
    unauthenticated :user do
      root :to => 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  namespace :api do
    namespace :v1 do
      resources :time_tables, :only => [:index, :show]
      resources :connection_links, :only => [:index, :show]
      resources :companies, :only => [:index, :show]
      resources :networks, :only => [:index, :show]
      resources :stop_areas, :only => [:index, :show]
      resources :group_of_lines, :only => [:index, :show]
      resources :access_points, :only => [:index, :show]
      resources :access_links, :only => [:index, :show]
      resources :lines, :only => [:index, :show] do
        resources :journey_patterns, :only => [:index, :show]
        resources :routes, :only => [:index, :show] do
          resources :vehicle_journeys, :only => [:index, :show]
          resources :journey_patterns, :only => [:index, :show]
          resources :stop_areas, :only => [:index, :show]
        end
      end
      resources :routes, :only => :show
      resources :journey_patterns, :only => :show
      resources :vehicle_journeys, :only => :show
    end
  end

  resource :organisation, :only => [:show, :edit, :update] do
    resources :users
    resources :rule_parameter_sets
  end

  resources :referentials do
    resources :api_keys
    resources :autocomplete_stop_areas
    resources :autocomplete_time_tables
    resources :autocomplete_route_sections
    resources :autocomplete_timebands
    resources :group_of_lines do
      collection do
        get 'name_filter'
      end
    end

    resources :networks

    resources :lines do
      delete :index, on: :collection, action: :delete_all
      collection do
        get 'name_filter'
      end
      resources :routes do
        member do
          get 'edit_boarding_alighting'
          put 'save_boarding_alighting'
        end
        resources :journey_patterns do
          member do
            get 'new_vehicle_journey'
          end
          resource :route_sections_selector, path: 'sections' do
            post 'selection'
          end
        end
        resources :vehicle_journeys, :vehicle_journey_frequencies do
          get 'select_journey_pattern', :on => :member
          resources :vehicle_translations
          resources :time_tables
        end
        resources :vehicle_journey_imports
        resources :vehicle_journey_exports
      end
    end

    resources :import_tasks, :only => [:new, :create]
    resources :imports, :only => [:index, :show, :destroy] do
      member do
        get "imported_file"
        get "rule_parameter_set"
        get "compliance_check"
        get 'export', defaults: { format: 'zip' }
      end
    end

    resources :export_tasks, :only => [:new, :create] do
      collection do
        get 'references'
      end
    end

    resources :exports, :only => [:index, :show, :destroy]  do
      member do
        get "exported_file"
      end
    end

    resources :compliance_check_tasks, :only => [:new, :create] do
      collection do
        get 'references'
      end
    end

    resources :compliance_checks, :only => [:index, :show, :destroy] do
      member do
        get 'export', defaults: { format: 'zip' }
        get 'report'
        get 'rule_parameter_set'
      end
      collection do
        get 'references'
      end
    end

    resources :companies

    resources :time_tables do
      collection do
        get :tags
      end
      member do
        get 'duplicate'
      end
      resources :time_table_dates
      resources :time_table_periods
      resources :time_table_combinations
    end

    resources :timebands

    resources :access_points do
       resources :access_links
    end

    resources :stop_areas do
      resources :access_points do
        resources :access_links
      end
      resources :stop_area_copies
      resources :stop_area_routing_lines
      member do
        get 'add_children'
        get 'select_parent'
        get 'add_routing_lines'
        get 'add_routing_stops'
        get 'access_links'
      end
      collection do
        put 'default_geometry'
      end
    end

    resources :connection_links do
      resources :stop_areas
      member do
        get 'select_areas'
      end
    end
    resources :clean_ups

    resources :route_sections do
      collection  do
        get 'create_to_edit'
      end
    end
  end
  root :to => "referentials#index"

  get '/help/(*slug)' => 'help#show'

  get '/404', :to => 'errors#not_found'
  get '/422', :to => 'errors#server_error'
  get '/500', :to => 'errors#server_error'

end
