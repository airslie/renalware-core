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

  var _reloadMainRecipientContactPicker = function(callback) {
    $("#contact-selector-input").load(document.URL + " #contact-selector-input", callback);
  };

  var _reloadCCsList = function(callback) {
    $("#letter-ccs").load(document.URL + " #letter-ccs", callback);
  };

  var initNewContactAsMainRecipient = function() {
    var trigger = $("a[data-behaviour='add-new-contact-as-main-recipient']");

    if (trigger.length > 0) {
      var modal = new Renalware.Contacts.Modal($("#add-patient-contact-modal"), function(contact) {
        _reloadMainRecipientContactPicker(function() {
          $("#letter_main_recipient_attributes_addressee_id").val(contact.id);
        });
        _reloadCCsList();
      });
      modal.init();

      trigger.on("click", function(event) {
         event.preventDefault();
         modal.open();
      })
    }
  };

  var initNewContactAsCC = function() {
    var trigger = $("a[data-behaviour='add-new-contact-as-cc-recipient']");

    if (trigger.length > 0) {
      var modal = new Renalware.Contacts.Modal($("#add-patient-contact-as-cc-modal"), function(contact) {
        _reloadMainRecipientContactPicker();
        _reloadCCsList(function() {
          $("#cc-contact-" + contact.id).prop("checked", true);
        });
      });
      modal.init();

      trigger.on("click", function(event) {
         event.preventDefault();
         modal.open();
      })
    }
  };

  return {
    init: function () {
      hideOrShowContactSelector();
      bindOnLetterRecipientTypeChange();
      initNewContactAsMainRecipient();
      initNewContactAsCC();
    }
  };
})();

$(document).ready(Renalware.Letters.init);
