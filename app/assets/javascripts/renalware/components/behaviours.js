$(document).ready(function() {
  $("[data-behaviour='submit']").click(function(e) {
    e.preventDefault();
    $(this).closest('form').submit();
  });

  $("[data-behaviour='submit_on_change']").on('change', function(e) {
    e.preventDefault();
    $(this).closest('form').submit();
  });
});
