var Renalware = typeof Renalware === 'undefined' ? {} : Renalware;

Renalware.MasonryHelper = (function() {
  var setupMasonry = function() {
    $('.mgrid > .row').masonry({ itemSelector: '.columns' });
  }

  var refreshMasonry = function() {
    $('.mgrid > .row').masonry('layout');
  }

  var triggerMasonryRefresh = function() {
    setTimeout(refreshMasonry, 100);
  }

  var createHandlerToTriggerMasonryRefresh = function() {
    $("[data-trigger-masonry-refresh]").on("click", triggerMasonryRefresh);
  }

  return {
    init: function () {
      setupMasonry();
      createHandlerToTriggerMasonryRefresh();
    }
  };
}());

$(document).ready(Renalware.MasonryHelper.init);
