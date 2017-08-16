# Create admin user
if User.all.blank?
  admin = User.new(email: ENV['ADMIN_EMAIL'], password: ENV['ADMIN_PASSWORD'],
                   password_confirmation: ENV['ADMIN_PASSWORD'], role: 'admin',
                   first_name: ENV['ADMIN_FIRST_NAME'], last_name: ENV['ADMIN_LAST_NAME'])
  admin.save!
end

# Reindex Post model with Elasticsearch
if Post.all.blank?
  Post.create(title: 'Temp post to perform Reindex')
  Post.reindex
  Post.where(title: 'Temp post to perform Reindex').destroy_all
end

# Create default Booking Link Types
if BookingLinkType.all.blank?
  BookingLinkType.create(name: 'Hotel', url_type: 'hotel')
  BookingLinkType.create(name: 'Restaurant', url_type: 'restaurant')
  BookingLinkType.create(name: 'Airbnb', url_type: 'airbnb')
  BookingLinkType.create(name: 'Attraction', url_type: 'attraction')
  BookingLinkType.create(name: 'Rental', url_type: 'rental')
  BookingLinkType.create(name: 'Flight', url_type: 'flight')
  BookingLinkType.create(name: 'Tour', url_type: 'tour')
  BookingLinkType.create(name: 'Activity', url_type: 'activity')
end
