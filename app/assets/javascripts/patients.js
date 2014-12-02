// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function() {
  $("a").click(function() {
    $(this).toggleClass( "fi-plus", "fi-minus");
  });
});