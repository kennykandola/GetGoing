$(".places.index").ready ->
  input = document.getElementById('place-input')
  autocomplete = new (google.maps.places.Autocomplete)(input)
  place = autocomplete.getPlace()
