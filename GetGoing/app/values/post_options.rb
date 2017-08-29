class PostOptions
  @@who_is_traveling_options = { myself: 'Myself - Solo',
                                 significant: 'Significant Other',
                                 family: 'Family',
                                 friends: 'Friends',
                                 other: 'Other (Describe Below)' }
  @@travel_style_options = { local: "Like a Local",
                             explore_attractions: "Explore the Main Attractions",
                             easygoing: "Easygoing - need some downtime",
                             constantly: "Constantly doing things",
                             save_hotel: "Save on the hotel - splurge on other things",
                             splurge_hotel: "Splurge on the hotel - save on other things"
                            }

  @@amenities_options = [
    'Restaurant',
    'Business services',
    'Pets Allowed',
    'Spa',
    'Airport Transportation',
    'Concierge',
    'Golf course',
    'Casino',
    'Internet',
    'Meeting room',
    'Non-Smoking Hotel',
    'Reduced mobility rooms',
    'Air Conditioning',
    'Free Wifi',
    'Breakfast included',
    'Pool',
    'Kitchenette',
    'Wheelchair access',
    'Bar/Lounge',
    'Suites',
    'Room Service',
    'Fitness center',
    'Free Parking'
  ]

  def self.amenities_options
    @@amenities_options
  end

  def self.who_is_traveling(who_is_traveling_key)
    @@who_is_traveling_options[who_is_traveling_key]
  end

  def self.traveling_other?(who_is_traveling_value)
    !@@who_is_traveling_options.value?(who_is_traveling_value)
  end
end
