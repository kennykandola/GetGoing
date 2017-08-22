class PostOptions
  @@who_is_traveling_options = { myself: 'Myself - Solo',
                                 significant: 'Significant Other',
                                 family: 'Family',
                                 friends: 'Friends',
                                 other: 'Other (Describe Below)' }
  def self.who_is_traveling(who_is_traveling_key)
    @@who_is_traveling_options[who_is_traveling_key]
  end

  def self.traveling_other?(who_is_traveling_value)
    !@@who_is_traveling_options.value?(who_is_traveling_value)
  end
end
