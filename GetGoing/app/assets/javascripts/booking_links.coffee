$(".posts.show").ready ->
  clickByAuthor()

clickByAuthor = ->
  $('a[data-trackable]').click ->
    console.log $(this).data('trackable')
    $.ajax
      type: 'PATCH'
      url: "/booking_links/#{$(this).data('trackable')}/click_by_author"
