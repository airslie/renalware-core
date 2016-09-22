function initTogglers() {
  var togglers = $("a[data-behaviour='toggler']");
  if (togglers.length > 0) {
    $(togglers).on("click", function(event) {
      event.preventDefault();
      var toggled = $(event.target).attr("href");
      console.log(toggled);
      $(toggled).toggle();
    })
  }
}

$(function() {
  initTogglers();
});
