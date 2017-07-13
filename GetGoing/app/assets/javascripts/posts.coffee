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
    console.log(place)
    $('.nested-fields:last #place-google_id').val(place.place_id);
    $('.nested-fields:last #place-state').val(place.name);
    $('.nested-fields:last #place-city').val(place.formatted_address);

  initAutocomplete()
