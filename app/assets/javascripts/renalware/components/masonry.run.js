var Renalware = typeof Renalware === 'undefined' ? {} : Renalware;

Renalware.MasonryHelper = (function() {
  var setupMasonry = function() {
    $('.grid > .row').masonry({ itemSelector: '.columns' });
  }

  var refreshMasonry = function() {
    $('.grid > .row').masonry('layout');
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
