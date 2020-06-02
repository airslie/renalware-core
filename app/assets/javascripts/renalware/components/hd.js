var Renalware = typeof Renalware === 'undefined' ? {} : Renalware;

Renalware.HD = (function() {
  // This is pretty much a duplicate of Letters.pollBatchStatus and we will merge them soon
  var pollBatchStatus = function(url) {
    var POLL_INTERVAL = 2000; // ms
    var batch = {};
console.log("asas")
    // Check the current status of the TaskStatus object.
    var updateStatus = function() {
      $.ajax({
        method: 'GET',
        url: url,
        dataType: "JSON"
      }).fail(function(e, x, a) {
        // Possible network glitch or perhaps a re-deploy causing the site to be down momentarily.
        // Anyway, not enough for us to give up polling.
        // TODO: examine the response code to see if we should in fact give up and show an
        // appropriate message.
        setTimeout(updateStatus, POLL_INTERVAL);
      }).done(function(batch) {
        $(".modal .percent_complete").html(batch.percent_complete + "%");

        switch(batch.status) {
          case 'awaiting_printing':
            $(".batch_results_container .preparing").hide();
            $(".batch_results_container .generated-batch-print-pdf-container").show();
            break;
          case 'failure':
            $(".batch_results_container .preparing").html("Failed");
            break;
          default:
            // Ask again in POLL_INTERVAL ms.
            setTimeout(updateStatus, POLL_INTERVAL);
        };
      });
    };
    setTimeout(updateStatus, POLL_INTERVAL);
  };

  return {
    init: function () {
      // nothing here yet
    },
    pollBatchStatus: pollBatchStatus
  };
}());

$(document).ready(Renalware.HD.init);
