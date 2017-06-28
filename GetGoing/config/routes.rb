Rails.application.routes.draw do

  root 'posts#index' # root page

  # Authentication routes
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks',
                                    registrations: 'registrations' }

  resources :subscribers

  get 'home/show'

  resources :posts do
    resources :responses
  end

  resources :booking_links, only: [:destroy] do
    member { put :upvote }
    member { put :downvote }
  end

  resources :users

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
