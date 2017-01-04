var Renalware = typeof Renalware === 'undefined' ? {} : Renalware;

Renalware.Renal = (function () {

  var setAllComobidityOptionsToNo = function() {
    $(document).on( "click", "a.set_all_comorbidities_to_no", function(e) {
      e.preventDefault();
      $(".comorbidities input[type=radio][value=no]").prop("checked", true);
    });
  };

  return {
    init : function() {
      setAllComobidityOptionsToNo();
    }
  }
})();

$(document).ready(Renalware.Renal.init);
