function initTogglers() {
  var togglers = $("a[data-behaviour='toggler']");
  if (togglers.length > 0) {
    $(togglers).on("click", function(event) {
      event.preventDefault();
      var toggled = $(event.target).attr("href");
      $(toggled).toggle();
    })
  }

  // css-toggler applies where you want a single line of text with a trailing ellipsis
  // contained in a .css-toggle-container to be expandable. Targeting the href selector here
  // will toggle the .expanded class on that element.
  // See the SCSS for what that class does, but it will probably take off the a nowrap and allow
  // the content to expand downwards so it is all visible.
  // This is useful for expanding content in a table cell for example.
  var togglers = $("a[data-behaviour='css-toggler']");
  if (togglers.length > 0) {
    $(togglers).on("click", function(event) {
      event.preventDefault();
      var selectorsToToggle = $(event.target).attr("href");
      $(selectorsToToggle).toggleClass("expanded");
    })
  }
}

$(function() {
  initTogglers();
});
