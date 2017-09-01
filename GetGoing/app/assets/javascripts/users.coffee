# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(".users.show").ready ->
  openTabFromUrl()
  askQuestion()

openTabFromUrl = ->
  hash = window.location.hash
  hash and $("ul.nav.nav-tabs a[href='#{hash}']").tab('show')
  $('.nav-tabs a').click ->
    document.location.href = document.location.href.split('?page=')[0] + '#' + this.href.split('#')[1]

askQuestion = ->
  if $("[data-question]").data('question')
    $.get('/users/tippa_question')
