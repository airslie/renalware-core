$(document).ready(function() {
  Mousetrap.bind('ctrl+f', function() {
    $(".patient-search-form input").focus();
  });

  Mousetrap.bind('ctrl+m', function() {
    $("#send-patient-message").trigger("click");
  });
});
