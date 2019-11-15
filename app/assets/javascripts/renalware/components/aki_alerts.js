var Renalware = typeof Renalware === 'undefined' ? {} : Renalware;

Renalware.AkiAlerts = (function () {

  var wireUpSetFilterDateToToday = function() {
    $(document).on( "click", "a.set_filter_date_to_today", function(e) {
      e.preventDefault();
      $("#q_date").val(moment().format("DD-MMM-YYYY"))
    });
  };

  var wireUpSetFilterDateAnyDate = function() {
    $(document).on( "click", "a.set_filter_date_to_any_date", function(e) {
      e.preventDefault();
      $("#q_date").val("")
    });
  };

  return {
    init : function() {
      wireUpSetFilterDateToToday();
      wireUpSetFilterDateAnyDate();
    }
  }
})();

$(document).ready(Renalware.AkiAlerts.init);
