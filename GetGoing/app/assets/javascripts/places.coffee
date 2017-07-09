$(".places.index").ready ->
  googlePlaceAutocomplete()
  $('#place-input').change ->
    if $('#place-input').val() == ''
      $('#country').val('')
      $('#place_id').val('')
      $('#add-place').prop("disabled", true)
      
googlePlaceAutocomplete = ->
  input = document.getElementById('place-input')
  placeSearch = undefined
  autocomplete = undefined
  componentForm =
    country: 'long_name'
    place_id: 'place_id'

  initAutocomplete = ->
    # Create the autocomplete object, restricting the search to geographical
    # location types.
    autocomplete = new (google.maps.places.Autocomplete)(input, types: [ 'geocode' ])
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