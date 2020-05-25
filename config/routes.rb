# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'paytm#home'
  match '/paytm_payment' => 'paytm#start_payment', via: [:post], :as => :paytm_payment
  match '/confirm_payment' => 'paytm#verify_payment', via: [:post]
end
