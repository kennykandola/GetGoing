// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

$( "button#jQueryColorChange" ).click(function() {
    $(this).toggleClass( "selected" );

});

$(document).ready(function (){

    $( "button#jQueryColorChange" ).click(function() {     $(this).toggleClass( "selected" ); });
})

$(document).ready(function(){
    $(window).scroll(function(){
        btnBottom = $(".btt").offset().top + $(".btt").outerHeight();
        ftrTop = $(".footer").offset().top;
        if (btnBottom > ftrTop)
            $(".btt").css("bottom", btnBottom - ftrTop + $(".btt").outerHeight());
    });
});
$('#ranger').on 'input', ->
$('#target').text($('#ranger').val())

