var Renalware = typeof Renalware === 'undefined' ? {} : Renalware;

Renalware.Letters = (function() {
  var hideOrShowOtherAddress = function() {
    var recipient_type = $("input[name='letters_letter[recipient_attributes][source_type]']:checked").val();

    if (recipient_type === "") {
      $("#other-address").show();
    } else {
      $("#other-address").hide();
    }
  };

  var bindOnRecipientTypeChange = function() {
    $("form.edit_letters_letter, form.new_letters_letter").change(hideOrShowOtherAddress);
  };

  return {
    init: function () {
      hideOrShowOtherAddress();
      bindOnRecipientTypeChange();
    }
  };
})();

$(document).ready(Renalware.Letters.init);
