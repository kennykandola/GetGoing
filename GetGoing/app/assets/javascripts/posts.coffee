$(".posts.new").ready ->
  googlePlaceAutocomplete()
  cocoonCallbacks()

$(".posts.edit").ready ->
  googlePlaceAutocomplete()
  cocoonCallbacks()

cocoonCallbacks = ->
  $('#places').on('cocoon:before-insert', (e, task_to_be_added) ->
    task_to_be_added.fadeIn 'slow'
    return
  ).on('cocoon:after-insert', (e, added_task) ->
    $('#place-input').val('')
    return
  ).on 'cocoon:before-remove', (e, task) ->
    $(this).data 'remove-timeout', 1000
    task.fadeOut 'slow'
    return

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
    country = place.address_components.find(isCountry)
    state = place.address_components.find(isState)
    city = place.address_components.find(isCity)
    $('.nested-fields:last #place-google_id').val(place?.place_id);
    $('.nested-fields:last #place-country').val(country?.long_name);
    $('.nested-fields:last #place-state').val(state?.short_name);
    $('.nested-fields:last #place-city').val(city?.long_name);

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
