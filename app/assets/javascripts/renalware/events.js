$(document).ready(function() {
  $("#event-type-dropdown").on("change", function(e) {
    e.preventDefault();
    var url = $(this).find(':selected').data("source")
    $.getScript(url);
  });
});
