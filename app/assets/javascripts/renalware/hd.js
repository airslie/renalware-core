/*
  These are functions relating to the authorisation by nurse + witness of prescriptions
  within the HD Session form.
  TODO: This needs refactoring.
*/
$(document).ready(function() {
  /*
  If enter is pressed in a password field (out of habit as enter is oftern used when logging in,
  after entering their password) throw it away. We could map it to a tab but frankly that gets
  a bit complicated - see here:
  https://stackoverflow.com/questions/2335553/jquery-how-to-catch-enter-key-and-change-event-to-tab
  */
  $("input.user-password").on("keypress", function(e) {
    if (e.keyCode == 13) { return false; }
  });

  $(".hd-drug-administered input[type='radio']").on("change", function(e) {
    var checked = ($(this).val() == "true");
    var container = $(this).closest(".hd-drug-administration");
    $(container).toggleClass("administered", checked)
    $(container).toggleClass("not-administered", !checked)
    $(container).removeClass("undecided");
    $(".authentication", container).toggle(checked)
    $(".authentication", container).toggleClass("disabled-with-faded-overlay", !checked)
    $(".reason-why-not-administered", container).toggle(!checked)
  });

  $(".hd-drug-administration .authentication-user-id").on("select2:select", function(e) {
    var container = $(this).closest(".user-and-password");
    var topContainer = $(container).closest(".hd-drug-administration")
    $(container).find(".authentication-token").val("")
    $("input.user-password", container).val("");
    $(container).removeClass("authorised");
    var tokenCount = $(topContainer).find(".authorised").length;
    $(topContainer).attr("data-token-count", tokenCount);
  });


  // When a user clicks the link to clear the authorisation (they might have used the wrong user
  // for instance) the clear the relevant token and password fields and classes.
  $(".hd-drug-administration .user-and-password .user-and-password--clear").on("click", function(e) {
    e.preventDefault();
    var container = $(this).closest(".user-and-password");
    var topContainer = $(container).closest(".hd-drug-administration")
    $(container).find(".authentication-token").val("")
    $("input.user-password", container).val("");
    $(container).removeClass("authorised");
    var tokenCount = $(topContainer).find(".authorised").length;
    $(topContainer).attr("data-token-count", tokenCount);
  });

  // When the user has entered a password and leaves the password field, make an ajax POST to
  // authenticate the user and on success return an authorisation token which is added to the html
  // form - it will be validated when the form is submitted.
  // TODO: also do this if enter pressed while in the password field.
  $(".user-and-password input.user-password").on("blur", function(e) {
    var container = $(this).closest(".user-and-password");
    var topContainer = $(container).closest(".hd-drug-administration")
    var authUrl = $(container).closest(".authentication").data("authentication-url");
    var userSelect = $(container).find(".authentication-user-id");
    var userId = $(userSelect).find("option:selected").val();
    var authorisationTokenHiddenField = $(container).find(".authentication-token");
    var password = $(this).val();

    // Prevent the a 401 xhr code from redirecting us to the login page - see ajax_errors.js
    $(document).off('ajaxError');

    if (userId && password) {
      $.ajax({
        async: false, /* needed as if pwd field has focus and user clicks submit, it would not wait for ajax */
        url: authUrl,
        type: "POST",
        data: "[user][id]=" + userId + "&[user][password]=" + password,
        beforeSend: function() {
          // Add a 'working' class during ajax operations so we can show a spinner for example
          $(container).addClass("working");
          $(container).removeClass("error");
          // $(".hd-session-form button[type='submit]").prop("disabled", "disabled")
        },
        complete: function() {
          $(container).removeClass("working");
          // $(".hd-session-form input[type='submit']").removeProp("disabled")
        },
        statusCode: {
          200: function (token) {
            // The user id/password combination is valid and a token has been returned.
            // We save the token to a hidden field so it wikll be submitted in the session form.
            $(authorisationTokenHiddenField).val(token);
            $(container).removeClass("unauthorised").addClass("authorised").removeClass("error");
            // $(userSelect).prop("disabled", true);
            var tokenCount = $(topContainer).find(".authorised").length;
            $(topContainer).attr("data-token-count", tokenCount);

          },
          401: function (data) {
            // The user id/password combination was not valid
            console.log('401: Unauthenticated');
            $(authorisationTokenHiddenField).prop("value", "");
            $(container).removeClass("authorised").addClass("error");

            var tokenCount = $(topContainer).find(".authorised").length;
            $(topContainer).attr("data-token-count", tokenCount);
          }
        }
      });
    }
  });
});
