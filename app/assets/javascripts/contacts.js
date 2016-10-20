var Renalware = typeof Renalware === 'undefined' ? {} : Renalware;

Renalware.Contacts = {
  Form: function(el, callback) {
    this.el = el,
    this.errorsContainer = this.el.find(".errors-container"),
    this.errorsList = this.errorsContainer.find("ul.error-messages"),
    this.callback = callback,

    this.init = function() {
      var self = this;
      this.el.on("submit", function(event) { self._onSubmit(event) });
    },

    this.reset = function() {
      this._clearForm();
      this._clearErrors();
    },

    this._clearForm = function() {
      this.el.trigger("reset");
      this.el.find(".hidden").val("");
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

      var valuesToSubmit = this.el.serialize();
      var self = this;

      self._clearErrors();
      $.ajax({
        type: "POST",
        url: self.el.attr("action"), //submits it to the given url of the form
        data: valuesToSubmit,
        dataType: "JSON",
        statusCode: {
          201: function(contact) {
            self._onSuccess(contact);
          },
          400: function(jqXHR) {
            var errors = jqXHR.responseJSON;
            self._onErrors(errors);
          }
        }
      });
    },

    this._onSuccess = function(contact) {
      this.callback(contact);
    },

    this._onErrors = function(errors) {
      this._clearErrors();
      this._addErrors(errors);
    }
  },

  Modal: function(el, callback) {
    this.el = el,
    this.forms = [],
    this.callback = callback,

    this.init = function() {
      var self = this;
      this.forms = this.el.find("form").map(function() {
        var form = new Renalware.Contacts.Form($(this), function(contact) {
          self._onContactAdded(contact);
        });
        form.init();
        return(form);
      });
    },

    this.open = function() {
      this.el.foundation("reveal", "open");
      this._resetForms();
    },

    this._resetForms = function() {
      this.forms.each(function() {
        this.reset();
      })
    },

    // event handlers

    this._onSubmit = function(event) {
      event.preventDefault();

      var valuesToSubmit = this.form.serialize();
      console.log(valuesToSubmit);
      var self = this;

      self._clearErrors();
      $.ajax({
        type: "POST",
        url: self.form.attr("action"), //submits it to the given url of the form
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
    }
  }
};

$(document).ready(function() {
  var trigger = $("a[data-behaviour='add-new-contact']");

  if (trigger.length > 0) {
    var modal = new Renalware.Contacts.Modal($("#add-patient-contact-modal"), function(contact) {
      $.getScript(document.URL);
    });
    modal.init();

    trigger.on("click", function(event) {
       event.preventDefault();
       modal.open();
    })
  }
});