var Renalware = typeof Renalware === 'undefined' ? {} : Renalware;

Renalware.Doctors = (function () {
  // private closure methods
  var initSelect2 = function () {
    $('#doctor_practice_ids').select2();
  };

  var bindAddressFormToggle = function () {
    $('#address-form-toggle').click(function (e) {
      var button = $(e.target);
      $(button.attr('href')).toggle();
    });
  };

  return {
    // public interface
    init : function () {
      initSelect2();
      bindAddressFormToggle();
    }
  }
})();

$(document).ready(Renalware.Doctors.init);
