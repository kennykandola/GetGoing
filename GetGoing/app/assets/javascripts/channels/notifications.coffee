if $('meta[name=action-cable-url]').length
  App.notifications = App.cable.subscriptions.create "NotificationsChannel",
    connected: ->
      # Called when the subscription is ready for use on the server

    disconnected: ->
      # Called when the subscription has been terminated by the server

    received: (data) ->
      # Called when there's incoming data on the websocket for this channel
      $('#notifications-component').html(data.notifications_html)
      $('#dropdownButton').click ->
        $.ajaxSetup({
          headers: { 'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content') }
        });
        $.ajax "/notifications/mark_as_read",
          dataType: "JSON"
          method: "PATCH"
          success: ->
            # $('#dropdownButton').data('counter', 0)
            document.getElementById("dropdownButton").dataset.counter = '';
