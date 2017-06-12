function initTabs() {
  function masonryLayoutRefresh() {
    $('.grid > .row').masonry('layout');
  }

  function triggerMasonryLayoutRefresh() {
    setTimeout(masonryLayoutRefresh, 200)
  }

  $(".tab-strip a").on("click", triggerMasonryLayoutRefresh);
}

$(function() {
  initTabs();
});
