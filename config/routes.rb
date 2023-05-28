# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  namespace :engineering do
    resources :okrs, only: [:index]

    resources :prs, only: [:index, :show]
  end
end
