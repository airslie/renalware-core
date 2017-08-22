function initTogglers() {

  function triggerMasonryLayoutRefresh() {
    $('.grid > .row').masonry('layout');
  }

  var togglers = $("a[data-behaviour='toggler']");
  if (togglers.length > 0) {
    $(togglers).on("click", function(event) {
      event.preventDefault();
      // Get e.g. the tr to toggle
      var toggled = $(event.target).attr("href");
      $(toggled).toggle();
      // If we are toggling open tr B by clicking a link within tr A above it,
      // add a class to the tr A sibling above it so it can also be styled
      // to match the expanded TR B below it, to create a clear connection between the two.
      $(toggled).prev().toggleClass("content-toggled");
      triggerMasonryLayoutRefresh();
    })
  }

  // css-toggler applies where you want a single line of text with a trailing ellipsis
  // contained in a .css-toggle-container to be expandable. Targeting the href selector here
  // will toggle the .expanded class on that element.
  // See the SCSS for what that class does, but it will probably take off the nowrap and allow
  // the content to expand downwards so it is all visible.
  // This is useful for expanding content in a table cell for example.
  var togglers = $("a[data-behaviour='css-toggler']");
  if (togglers.length > 0) {
    $(togglers).on("click", function(event) {
      event.preventDefault();
      var selectorsToToggle = $(event.target).attr("href");
      $(selectorsToToggle).toggleClass("expanded");
      triggerMasonryLayoutRefresh();
    })
  }
}

$(function() {
  initTogglers();
});
