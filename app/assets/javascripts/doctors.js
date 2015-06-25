var Renalware = typeof Renalware === 'undefined' ? {} : Renalware;

Renalware.Doctors = (function () {
  // private closure methods
  var initSelect2 = function () {
    $('#doctor_practice_ids').select2();
  };

  return {
    // public interface
    init : function () {
      initSelect2();
    }
  }
})();

$(document).ready(Renalware.Doctors.init);
