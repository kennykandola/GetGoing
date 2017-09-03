require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module GetGoing
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.active_job.queue_adapter = :sidekiq
    config.assets.paths << Rails.root.join('vendor', 'assets', 'javascripts')
    config.assets.paths << Rails.root.join('vendor', 'assets', 'stylesheets')
    config.to_prepare do
      # Configure mailer layout
      Devise::Mailer.layout 'mailer'
    end
  end
end
