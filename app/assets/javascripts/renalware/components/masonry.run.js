var Renalware = typeof Renalware === 'undefined' ? {} : Renalware;

Renalware.MasonryHelper = (function() {
  var masonryIsSetup = false;
  var turboFrameLoadHandlerCreated = false;

  var setupMasonry = function() {
    var $grid = $('.mgrid > .row');
    if ($grid.length === 0 || !$.fn.masonry) {
      return;
    }

    $grid.masonry({ itemSelector: '.columns' });
    masonryIsSetup = true;
  }

  var refreshMasonry = function() {
    if (!$.fn.masonry) {
      return;
    }

    if (!masonryIsSetup) {
      setupMasonry();
    }

    $('.mgrid > .row').masonry('layout');
  }

  var triggerMasonryRefresh = function() {
    setTimeout(refreshMasonry, 100);
  }

  var triggerMasonryRefreshAfterFrameLoad = function(event) {
    if (event.target.closest('.mgrid')) {
      triggerMasonryRefresh();
    }
  }

  var createHandlerToTriggerMasonryRefresh = function() {
    $("[data-trigger-masonry-refresh]").on("click", triggerMasonryRefresh);
  }

  var createHandlerToRefreshMasonryAfterFrameLoad = function() {
    if (turboFrameLoadHandlerCreated) {
      return;
    }

    document.addEventListener("turbo:frame-load", triggerMasonryRefreshAfterFrameLoad);
    turboFrameLoadHandlerCreated = true;
  }

  return {
    init: function () {
      setupMasonry();
      createHandlerToTriggerMasonryRefresh();
      createHandlerToRefreshMasonryAfterFrameLoad();
    },
    observeTurboFrameLoads: createHandlerToRefreshMasonryAfterFrameLoad,
    refresh: triggerMasonryRefresh
  };
}());

Renalware.MasonryHelper.observeTurboFrameLoads();
$(document).ready(Renalware.MasonryHelper.init);
