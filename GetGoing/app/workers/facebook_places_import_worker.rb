class FacebookPlacesImportWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false

  def perform(user_id)
    user = User.find(user_id)
    import_places_service = ImportPlacesService.new(user: user)
    import_places_service.add_tagged_places
    import_places_service.add_hometown if user.hometown.blank?
    import_places_service.add_location if user.current_location.blank?
  end
end
