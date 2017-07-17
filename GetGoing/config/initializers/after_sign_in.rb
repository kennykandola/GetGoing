Warden::Manager.after_set_user except: :fetch do |user, auth, opts|
  FacebookPlacesImportWorker.perform_async(user.id) if user.facebook.present?
end
