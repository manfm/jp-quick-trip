function getLocation() {
  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(injectPositionInForm);
  } else {
    alertError("Geolocation is not supported by this browser.");
    disableForm();
  }
}

function injectPositionInForm(position) {
  $("input[name='lat']").val(position.coords.latitude);
  $("input[name='lng']").val(position.coords.longitude);
}

function alertError(message) {
  $("#error-text").html(message);

  $("#alert-error").removeClass("hidden");
  $("#alert-ok").addClass("hidden");
}

function alertOk(prefecture) {
  $("#city").html(prefecture);

  $("#alert-ok").removeClass("hidden");
  $("#alert-error").addClass("hidden");

  $("#form-with-email").addClass("hidden");
}

function disableForm() {
  $("#form-with-email :input").attr("disabled", true);
}

function enableForm() {
  $("#form-with-email :input").attr("disabled", false);
}

$(function() {
  //get location from browser when page loads
  getLocation();

  $("#form-with-email")
    .submit(function(event) {
      url = $("#form-with-email").attr('location') + ".json";

      $.ajax({
        url: url,
        type: 'POST',
        beforeSend: function(xhr) {
          xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
        },
        data: $(this).serialize(),
        success: function() {},
        statusCode: {
          201: function(response) {
            alertOk(response.responseText);
            disableForm();
          },
          406: function(response) {
            alertError(response.responseText);
            enableForm();
          },
          503: function(response) {
            alertError(response.responseText + "<br> Please try resend form");
            enableForm();
          }
        }
      });

      disableForm();

      event.preventDefault();
    });
});
