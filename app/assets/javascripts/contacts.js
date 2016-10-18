var Renalware = typeof Renalware === 'undefined' ? {} : Renalware;

Renalware.Contacts = {
  Modal: function(el, callback) {
    this.el = el,
    this.form = this.el.find("form"),
    this.errorsContainer = this.form.find(".errors-container"),
    this.errorsList = this.errorsContainer.find("ul.error-messages"),
    this.callback = callback,

    this.init = function() {
      var self = this;
      this.form.on("submit", function(event) { self._onSubmit(event) });
    },

    this.open = function() {
      this.el.foundation("reveal", "open");
      this._clearForm();
      this._clearErrors();
    },

    this._clearForm = function() {
      this.form.trigger("reset");
      this.form.find(".hidden").val("");
    },

    this._addErrors = function(errors) {
      var list = this.errorsList;
      this.errorsContainer.show();
      $.each(errors, function(i) {
        list.append("<li>" + errors[i] + "</li>");
      });
    },

    this._clearErrors = function() {
      this.errorsList.html("");
      this.errorsContainer.hide();
    },

    // event handlers

    this._onSubmit = function(event) {
      event.preventDefault();

      var valuesToSubmit = this.form.serialize();
      var self = this;

      this._clearErrors();
      $.ajax({
        type: "POST",
        url: $(this).attr("action"), //sumbits it to the given url of the form
        data: valuesToSubmit,
        dataType: "JSON",
        statusCode: {
          201: function(contact) {
            self._onContactAdded(contact);
          },
          400: function(jqXHR) {
            var errors = jqXHR.responseJSON;
            self._onErrors(errors);
          }
        }
      });
    },

    this._onContactAdded = function(contact) {
      this.el.foundation('reveal', 'close');
      this.callback(contact);
    },

    this._onErrors = function(errors) {
      this._clearErrors();
      this._addErrors(errors);
    }
  }
};

$(document).ready(function() {
  var modal = new Renalware.Contacts.Modal($("#add-patient-contact-modal"), function(contact) {
    $.getScript(document.URL);
  });
  modal.init();

  $("a[data-behaviour='add-new-contact']").on("click", function(event) {
     event.preventDefault();
     modal.open();
  })
});
