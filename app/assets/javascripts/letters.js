var Renalware = typeof Renalware === 'undefined' ? {} : Renalware;

Renalware.Letters = (function() {
  var hideOrShowOtherAddress = function() {
    var recipient_type = $("input.recipient-person-role-picker:checked").val();

    if (recipient_type === "other") {
      $("#other-address").show();
    } else {
      $("#other-address").hide();
    }
  };

  var bindOnLetterRecipientTypeChange = function() {
    $("form.edit_letters_letter, form.new_letters_letter").change(hideOrShowOtherAddress);
  };

  return {
    init: function () {
      hideOrShowOtherAddress();
      bindOnLetterRecipientTypeChange();
    }
  };
})();

$(document).ready(Renalware.Letters.init);
