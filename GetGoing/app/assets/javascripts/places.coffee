$(".places.index").ready ->

  input = document.getElementById('place-input')
  placeSearch = undefined
  autocomplete = undefined
  componentForm =
    # street_number: 'short_name'
    # route: 'long_name'
    # locality: 'long_name'
    # administrative_area_level_1: 'short_name'
    country: 'long_name'
    # postal_code: 'short_name'
    place_id: 'place_id'

  $('#place-input').change ->
    if input.value == ''
      document.getElementById('country').value = ''
      document.getElementById('place_id').value = ''
      document.getElementById('add-place').disabled = true

  initAutocomplete = ->
    # Create the autocomplete object, restricting the search to geographical
    # location types.
    autocomplete = new (google.maps.places.Autocomplete)(input, types: [ 'geocode' ])
    # When the user selects an address from the dropdown, populate the address
    # fields in the form.
    autocomplete.addListener 'place_changed', fillInAddress
    return

  fillInAddress = ->
    # Get the place details from the autocomplete object.
    place = autocomplete.getPlace()
    console.log(place)
    for component of componentForm
      document.getElementById(component).value = ''
      document.getElementById('add-place').disabled = false
    # Get each component of the address from the place details
    # and fill the corresponding field on the form.
    i = 0
    while i < place.address_components.length
      addressType = place.address_components[i].types[0]
      if componentForm[addressType]
        val = place.address_components[i][componentForm[addressType]]
        document.getElementById(addressType).value = val
      i++
    document.getElementById('place_id').value = place.place_id

  initAutocomplete()
