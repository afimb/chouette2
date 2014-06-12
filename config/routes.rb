ChouetteIhm::Application.routes.draw do

  devise_scope :users do
    match "/users/sign_up" => "subscriptions#new"
  end
  devise_for :users

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


  resource :subscription

  resource :organisation do
    resources :users
  end

  resources :referentials do
    resources :api_keys
    resources :rule_parameter_sets
    resources :stop_point_areas
    match 'lines' => 'lines#destroy_all', :via => :delete
    resources :group_of_lines do
      resources :stop_areas do
        resources :access_points
        resources :stop_area_parents
        resources :stop_area_children
        resources :stop_area_routing_lines
        resources :stop_area_routing_stops
        member do
          get 'add_children'
          get 'select_parent'
          get 'add_routing_lines'
          get 'add_routing_stops'
        end
      end
      resources :lines
      collection do
        get :name_filter
      end
    end

    resources :lines do
      collection do
        get :name_filter
      end
    end

    resources :lines, :networks, :group_of_lines do
      resources :stop_areas do
        resources :access_points
        resources :stop_area_parents
        resources :stop_area_children
        resources :stop_area_routing_lines
        resources :stop_area_routing_stops
        member do
          get 'add_children'
          get 'select_parent'
          get 'add_routing_lines'
          get 'add_routing_stops'
        end
      end
      resources :routes do
        resources :journey_patterns do
          member do
            get 'new_vehicle_journey'
          end
        end
        resources :vehicle_journeys do
          get 'timeless', :on => :collection
          get 'select_journey_pattern', :on => :member
          resources :vehicle_translations
        end
        resources :vehicle_journey_imports
        resources :vehicle_journey_exports
      end
    end

    resources :import_tasks do
      member do
        get 'file_to_import'
      end
    end

    resources :exports do
      collection do
        get 'references'
      end
    end
    resources :compliance_check_tasks do
      member do
        get 'rule_parameter_set'
      end
      collection do
        get 'references'
      end

      resources :compliance_check_results
    end

    resources :companies

    resources :time_tables do
      collection do
        get :comment_filter
      end
      resources :time_table_dates
      resources :time_table_periods
    end

    resources :access_points do
       resources :access_links
    end

    resources :stop_areas do
      resources :access_points
      resources :stop_area_parents
      resources :stop_area_children
      resources :stop_area_routing_lines
      resources :stop_area_routing_stops
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
      resources :connection_link_areas
      member do
        get 'select_areas'
      end
      resources :stop_areas do
        resources :access_points
        resources :stop_area_parents
        resources :stop_area_children
        resources :stop_area_routing_lines
        resources :stop_area_routing_stops
        member do
          get 'add_children'
          get 'select_parent'
          get 'add_routing_lines'
          get 'add_routing_stops'
        end
      end
    end

    resources :clean_ups

  end

  match '/help/(*slug)' => 'help#show'

  match '/404', :to => 'errors#not_found'
  match '/422', :to => 'errors#server_error'
  match '/500', :to => 'errors#server_error'

  root :to => 'referentials#index'
end
