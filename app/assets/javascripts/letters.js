var Renalware = typeof Renalware === 'undefined' ? {} : Renalware;

Renalware.Letters = (function() {
  var hideOrShowContactSelector = function() {
    var recipient_type = $("input.recipient-person-role-picker:checked").val();

    if (recipient_type === "contact") {
      $("#contact-selector").show();
    } else {
      $("#contact-selector").hide();
    }
  };

  var bindOnLetterRecipientTypeChange = function() {
    $("#letter-form").change(hideOrShowContactSelector);
  };

  return {
    init: function () {
      hideOrShowContactSelector();
      bindOnLetterRecipientTypeChange();
    }
  };
})();

$(document).ready(Renalware.Letters.init);
