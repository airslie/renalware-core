var Renalware = typeof Renalware === 'undefined' ? {} : Renalware;

Renalware.Messaging = (function() {
  var focusRecipientSearchInput = function() {
    $('#message_recipient_ids').select2('open').select2('close');
  };

  return {
    init: function () {
      focusRecipientSearchInput()
    }
  };
})();

$(document).on('opened.fndtn.reveal', '#send-message-modal', Renalware.Messaging.init);
