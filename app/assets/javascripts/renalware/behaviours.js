$(document).ready(function() {
  $("[data-behaviour='highlight'] tbody tr a").click(function(){
      $(this).closest("tr").addClass("is-selected").siblings().removeClass("is-selected");
  });

  $("[data-behaviour='submit']").click(function(e) {
    e.preventDefault();
    $(this).closest('form').submit();
  });

  $("[data-behaviour='submit_on_change']").on('change', function(e) {
    e.preventDefault();
    $(this).closest('form').submit();
  });
});
