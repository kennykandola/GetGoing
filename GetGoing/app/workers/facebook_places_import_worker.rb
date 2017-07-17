class FacebookPlacesImportWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false

  def perform(user_id)
    user = User.find(user_id)
    import_places_service = ImportPlacesService.new(user: user)
    import_places_service.import
    import_places_service.add_hometown
    import_places_service.add_location
  end
end
