require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do

  root 'posts#index' # root page

  mount ActionCable.server => '/cable'

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
    resources :post_users, path: :users, module: :posts
    member { get :new_invitation }
    member { post :claim }
    member { patch :cancel_claim}
  end

  resources :responses, only: [] do
    resources :comments, only: [:new, :create, :destroy]
  end

  resources :notifications do
    collection do
      patch :mark_as_read
    end
  end

  resources :booking_links, only: [:index, :destroy] do
    member { patch :upvote }
    member { patch :downvote }
    member { patch :click_by_author }
    member { get :edit_affiliate_revenue }
    member { patch :update_affiliate_revenue }
  end

  scope '/manage' do
    resources :users, only: [:index] do
      member { patch :assign_as_admin }
      member { patch :assign_as_moderator }
      member { patch :assign_as_simple_user }
    end

    resources :booking_link_types
  end

  resources :users, only: [:show, :edit]

  resources :places, only: [:index, :destroy] do
    collection { post :add_place_to_user }
    member { patch :set_as_current_location }
    member { patch :set_as_hometown }
  end



  get 'profile', to: 'users#profile'

  get '/top' => 'responses#top'

  get '/top_email' => 'responses#top_email'

  get '/tippa' => 'users#tippa'

  get '/all_posts' => 'posts#all_posts'

  get 'edit', to: 'users#edit'

  get '/tippa_guide' => 'posts#tippa_guide'

  get '/show' => 'posts#show'

  get '/new_post_design' => 'posts#new_post_design'

  get 'upvote_link' => 'posts#show'

  devise_scope :user do
    get "/new_tippa" => "registrations#new_tippa"
  end
end
