class PostOptions
  @@who_is_traveling_options = { myself: 'Myself - Solo',
                                 significant: 'Significant Other',
                                 family: 'Family',
                                 friends: 'Friends',
                                 other: 'Other (Describe Below)' }
  @@travel_style_options = { local: 'Like a Local',
                             explore_attractions: 'Explore the Main Attractions',
                             easygoing: 'Easygoing - need some downtime',
                             constantly: 'Constantly doing things',
                             save_hotel: 'Save on the hotel - splurge on other things',
                             splurge_hotel: 'Splurge on the hotel - save on other things' }

  @@amenities_options = [
    'Free Wifi',
    'Pool',
    'Wheelchair access',
    'Fitness center'
    # 'Restaurant',
    # 'Business services',
    # 'Pets Allowed',
    # 'Spa',
    # 'Airport Transportation',
    # 'Concierge',
    # 'Golf course',
    # 'Casino',
    # 'Internet',
    # 'Meeting room',
    # 'Non-Smoking Hotel',
    # 'Reduced mobility rooms',
    # 'Air Conditioning',
    # 'Breakfast included',
    # 'Kitchenette',
    # 'Bar/Lounge',
    # 'Suites',
    # 'Room Service',
    # 'Free Parking'
  ]

  @@accomodation_style_options = [
    'Best Value',
    'Boutique',
    'Luxury',
    'Charming',
    'Quiet',
    'Romantic',
    'Mid-Range',
    'Trendy'
  ]

  @@traveler_rating_options = [1, 2, 3, 4]

  @@location_distance_options = [['0.5 mi', 0.5], ['1 mi', 1.0], ['3 mi', 3.0], ['5 mi', 5.0], ['10 mi', 10.0], ['25 mi', 25.0]]

  @@budget_options = ['$', '$$', '$$$', '$$$$', '$$$$$', '$$$$$$']

  @@people_total_options = [['2', 2], ['3', 3], ['4', 4], ['5', 5], ['6', 6], ['7+', 7]]

  def self.amenities_options
    @@amenities_options
  end

  def self.accomodation_style_options
    @@accomodation_style_options
  end

  def self.traveler_rating_options
    @@traveler_rating_options
  end

  def self.travel_style_options
    @@travel_style_options
  end

  def self.location_distance_options
    @@location_distance_options
  end

  def self.who_is_traveling_options
    @@who_is_traveling_options
  end
  
  def self.who_is_traveling(who_is_traveling_key)
    @@who_is_traveling_options[who_is_traveling_key]
  end

  def self.traveling_other?(who_is_traveling_value)
    !@@who_is_traveling_options.value?(who_is_traveling_value)
  end

  def self.budget_options
    @@budget_options
  end

  def self.people_total_options
    @@people_total_options
  end
end
