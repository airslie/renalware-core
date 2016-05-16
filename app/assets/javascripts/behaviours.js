$(document).ready(function() {
  $("a.fi-plus").click(function() {
    $(this).toggleClass("fi-plus", "fi-minus");
  });

  $("[data-behaviour='highlight'] tbody tr a").click(function(){
      $(this).closest("tr").addClass("is-selected").siblings().removeClass("is-selected");
  });
});
