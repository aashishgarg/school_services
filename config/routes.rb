# frozen_string_literal: true

Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  resource :session, only: %i[ new create destroy ]
  resources :passwords, param: :token, only: %i[ new create edit update ]

  root "dashboard#show"

  namespace :admin do
    root "dashboard#show"
    resource :settings, only: %i[ show update ]
    resources :academic_years
    resources :school_classes
    resources :sections do
      resources :teacher_assignments, only: %i[ create destroy ]
    end
    resources :students do
      collection do
        post :import
      end
    end
    resources :users
    resources :buses do
      resources :bus_stops, except: %i[ show ]
    end
    get "transport", to: "transport#index"
    get "attendance", to: "attendance#index"
    get "attendance/export", to: "attendance_exports#show", defaults: { format: :csv }, as: :export_attendance
    resources :audits, only: %i[ index ]
  end

  namespace :attendance do
    get "sections/:section_id/halves", to: "section_halves#show", as: :section_halves
    resources :sessions, only: %i[ index new create show edit update ]
  end

  namespace :transport do
    resources :trips, only: %i[ index show create ] do
      member do
        post :complete
      end
      resources :stop_progresses, only: %i[ update ]
    end
  end
end
