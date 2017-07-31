$(".places.index").ready ->
  googlePlaceAutocomplete()
  $('#place-input').change ->
    if $('#place-input').val() == ''
      $('#place-google_id').val('')
      $('#place-name').val('')
      $('#place-address').val('')
      $('#add-place').prop("disabled", true)

googlePlaceAutocomplete = ->
  input = document.getElementById('place-input')
  placeSearch = undefined
  autocomplete = undefined

  initAutocomplete = ->
    # Create the autocomplete object, restricting the search to geographical
    # location types.
    autocomplete = new (google.maps.places.Autocomplete)(input, types: [ '(cities)' ])
    # Disable form submit on enter (prevent unexpected sumbit on place autocomplete)
    google.maps.event.addDomListener input, 'keydown', (event) ->
      if event.keyCode == 13
        event.preventDefault()
      return
    # When the user selects an address from the dropdown, populate the address
    # fields in the form.
    autocomplete.addListener 'place_changed', fillInAddress
    return

  fillInAddress = ->
    # Get the place details from the autocomplete object.
    place = autocomplete.getPlace()
    console.log(place)
    country = place.address_components.find(isCountry)
    state = place.address_components.find(isState)
    city = place.address_components.find(isCity)
    $('#place-google_id').val(place?.place_id)
    $('#place-city').val(city?.long_name)
    $('#place-state').val(state?.short_name)
    $('#place-country').val(country?.long_name)
    $('#place-latitude').val(place?.geometry.location.lat())
    $('#place-longitude').val(place?.geometry.location.lng())
    $('#add-place').prop("disabled", false)

  isCity = (address_component) ->
    address_component.types[0] == 'locality' || \
      address_component.types[0] == 'postal_town' || \
      address_component.types[0] == 'administrative_area_level_3' || \
      address_component.types[0] == 'sublocality_level_1' || \
      address_component.types[0] == 'administrative_area_level_2'

  isState = (address_component) ->
    address_component.types[0] == 'administrative_area_level_1'

  isCountry = (address_component) ->
    address_component.types[0] == 'country'

  initAutocomplete()
