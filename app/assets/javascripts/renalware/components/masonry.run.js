var Renalware = typeof Renalware === 'undefined' ? {} : Renalware;

Renalware.MasonryHelper = (function() {
  var gridSelector = '.mgrid > .row';
  var itemSelector = '.columns';
  var turboFrameLoadHandlerCreated = false;

  var findGrids = function() {
    return Array.prototype.slice.call(document.querySelectorAll(gridSelector));
  }

  var setupMasonry = function(grid) {
    if (!window.Masonry || grid.renalwareMasonry) {
      return;
    }

    grid.renalwareMasonry = new window.Masonry(grid, { itemSelector: itemSelector });
    observeMasonryChanges(grid);
  }

  var refreshMasonry = function() {
    findGrids().forEach(function(grid) {
      setupMasonry(grid);

      if (grid.renalwareMasonry) {
        grid.renalwareMasonry.layout();
      }
    });
  }

  var triggerMasonryRefresh = function() {
    setTimeout(refreshMasonry, 100);
  }

  var observeGridItems = function(grid) {
    if (!grid.renalwareMasonryResizeObserver) {
      return;
    }

    Array.prototype.slice.call(grid.querySelectorAll(itemSelector)).forEach(function(item) {
      grid.renalwareMasonryResizeObserver.observe(item);
    });
  }

  var observeMasonryChanges = function(grid) {
    if (window.ResizeObserver && !grid.renalwareMasonryResizeObserver) {
      grid.renalwareMasonryResizeObserver = new ResizeObserver(triggerMasonryRefresh);
      observeGridItems(grid);
    }

    if (window.MutationObserver && !grid.renalwareMasonryMutationObserver) {
      grid.renalwareMasonryMutationObserver = new MutationObserver(function() {
        observeGridItems(grid);
        triggerMasonryRefresh();
      });

      grid.renalwareMasonryMutationObserver.observe(grid, {
        childList: true,
        subtree: true
      });
    }
  }

  var hasMasonryRefreshTrigger = function(element) {
    while (element && element !== document) {
      if (
        element.nodeType === 1 &&
        element.getAttribute("data-trigger-masonry-refresh") !== null
      ) {
        return true;
      }

      element = element.parentNode;
    }

    return false;
  }

  var isInsideMasonryGrid = function(element) {
    while (element && element !== document) {
      if (
        element.nodeType === 1 &&
        element.classList &&
        element.classList.contains("mgrid")
      ) {
        return true;
      }

      element = element.parentNode;
    }

    return false;
  }

  var triggerMasonryRefreshAfterFrameLoad = function(event) {
    if (isInsideMasonryGrid(event.target)) {
      triggerMasonryRefresh();
    }
  }

  var createHandlerToTriggerMasonryRefresh = function() {
    if (document.renalwareMasonryRefreshHandler) {
      return;
    }

    document.renalwareMasonryRefreshHandler = true;

    document.addEventListener("click", function(event) {
      if (hasMasonryRefreshTrigger(event.target)) {
        triggerMasonryRefresh();
      }
    });
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
      findGrids().forEach(setupMasonry);
      createHandlerToTriggerMasonryRefresh();
      createHandlerToRefreshMasonryAfterFrameLoad();
    },

    observeTurboFrameLoads: createHandlerToRefreshMasonryAfterFrameLoad,

    refresh: function () {
      triggerMasonryRefresh();
    }
  };
}());

Renalware.MasonryHelper.observeTurboFrameLoads();

if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", Renalware.MasonryHelper.init);
} else {
  Renalware.MasonryHelper.init();
}
