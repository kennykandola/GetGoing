$(document).ready ->
  $('#dropdownButton').click ->
    $.ajaxSetup({
      headers: { 'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content') }
    });
    $.ajax "/notifications/mark_as_read",
      dataType: "JSON"
      method: "PATCH"
      success: ->
        # $('#dropdownButton').data('counter', 0)
        document.getElementById("dropdownButton").dataset.counter = 0;
