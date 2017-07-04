require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do

  root 'posts#index' # root page

  # Authentication routes
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks',
                                    registrations: 'registrations' }

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  resources :subscribers

  get 'home/show'

  resources :posts do
    resources :responses do
      member { patch :set_top }
    end
  end

  resources :booking_links, only: [:destroy] do
    member { patch :upvote }
    member { patch :downvote }
  end

  scope '/manage' do
    resources :users do
      member { patch :assign_as_admin }
      member { patch :assign_as_moderator }
      member { patch :assign_as_simple_user }
    end
  end

  get 'profile', to: 'users#profile'

  get '/top' => 'responses#top'

  get '/top_email' => 'responses#top_email'

  get '/claim' => 'posts#claim'

  get '/claim_remove' => 'posts#claim_remove'

  get '/tippa' => 'users#tippa'

  get '/all_posts' => 'posts#all_posts'

  get 'edit', to: 'users#edit'

  get '/tippa_guide' => 'posts#tippa_guide'

  get '/show' => 'posts#show'

  get 'upvote_link' => 'posts#show'

  devise_scope :user do
    get "/new_tippa" => "registrations#new_tippa"
  end
end
