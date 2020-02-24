var Renalware = typeof Renalware === 'undefined' ? {} : Renalware;

Renalware.HDPrescriptionAdministration = (function() {

  /*
    These are functions relating to the authorisation by nurse + witness of prescriptions
    within the HD Session form.
    TODO: This needs refactoring.
  */
  var wireupEventHandlers = function() {

    /*
    If enter is pressed in a password field (out of habit as enter is oftern used when logging in,
    after entering their password) throw it away. We could map it to a tab but frankly that gets
    a bit complicated - see here:
    https://stackoverflow.com/questions/2335553/jquery-how-to-catch-enter-key-and-change-event-to-tab
    */
    $("input.user-password").on("keypress", function(e) {
      if (e.keyCode == 13) { return false; }
    });

    $(".hd-drug-administered input[type='radio']").on("change", function(e) {
      var checked = ($(this).val() == "true");
      var container = $(this).closest(".hd-drug-administration");
      $(container).toggleClass("administered", checked);
      $(container).toggleClass("not-administered", !checked);
      $(container).removeClass("undecided");
      $(".authentication", container).toggle(checked);
      $(".authentication", container).toggleClass("disabled-with-faded-overlay", !checked);
      $(".reason-why-not-administered", container).toggle(!checked);
      $("#btn_save_and_witness_later").toggle(checked);
    });
  };

  return {
    init: function () {
      wireupEventHandlers();
    }
  };
}());

$(document).ready(Renalware.HDPrescriptionAdministration.init);
