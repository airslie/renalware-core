var Renalware = typeof Renalware == 'undefined' ? {} : Renalware;

Renalware.Letters = (function () {
  var initAuthorsSelect2 = function () {
    $('#letter_author_id').select2();
  };

  var bindRecipientOnChange = function () {
    var $otherRecipientRadio = $('#letter_recipient_other'),
        $otherRecipientAddress = $('#other_recipient_address'),
        $knownRecipientRadios = $('#letter_recipient_doctor, #letter_recipient_patient');

    $otherRecipientRadio.change(function (e) {
      $otherRecipientAddress.prop('disabled', false);
    });

    $knownRecipientRadios.change(function (e) {
      $otherRecipientAddress.prop('disabled', true);
    });
  };

  return {
    init: function () {
      initAuthorsSelect2();
      bindRecipientOnChange();
    }
  };
})();

$(document).ready(Renalware.Letters.init);
