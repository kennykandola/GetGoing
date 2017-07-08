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
    $('.nested-fields:last #place_id').val(place.place_id);
    $('.nested-fields:last #name').val(input.value);
    i = 0
    while i < place.address_components.length
      addressType = place.address_components[i].types[0]
      if componentForm[addressType]
        val = place.address_components[i][componentForm[addressType]]
        $('.nested-fields:last #country').val(val);
      i++

  initAutocomplete()
