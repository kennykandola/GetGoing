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
    $('#place-google_id').val(place.place_id)
    $('#place-name').val(place.name)
    $('#place-address').val(place.formatted_address)
    $('#add-place').prop("disabled", false)

  initAutocomplete()
