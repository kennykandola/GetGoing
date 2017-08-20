# Be sure to restart your server when you modify this file.

# Rails.application.config.session_store :cookie_store, key: '_get_going_session'
# GetGoing::Application.config.session_store :redis_store, {
#   servers: [
#     {
#       host: ENV['SESSIONS_REDIS_HOST'],
#       port: ENV['SESSIONS_REDIS_PORT'],
#       db: ENV['SESSIONS_REDIS_DB'],
#       namespace: ENV['SESSIONS_REDIS_NAMESPACE']
#     }
#   ],
#   expire_after: 14.days,
#   key: "_#{Rails.application.class.parent_name.downcase}_session"
# }

GetGoing::Application.config.session_store :redis_store, servers: ["redis://redis:6379/2/session"]
