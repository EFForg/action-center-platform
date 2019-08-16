$(document).on("ready", function() {
  $("#congress-message-tool").on("ajax:beforeSend", function() {
    $(".progress-striped").show();
    $("input[type=submit]").hide();
    $("input,textarea,button,select", $(this)).attr("disabled", "disabled");
  });

  $(".congress-message-rep-lookup").on("ajax:complete", function(xhr, data, status) {
    var $form = $(this);
    if (status == "success") {
      $form.remove();
      $(".congress-message-tool-container").html(data.responseText);
      // Trigger phone field formatting.
      var $phone = $(".bfh-phone")
      $phone.bfhphone($phone.data());
      // @TODO auto-set similar fields, eg name prefix, when the first is set.
    } else if (data.responseText) {
      show_error(data.responseText, $form);
    } else {
      show_error("Something went wrong. Please try again later.", $form);
    }
  });

  $(document).on("ajax:complete", function(xhr, data, status) {
    if (xhr.target.id == "congress-message-create") {
      var $form = $(this);
      if (status == "success") {
        $("#congress-message-create").hide();
        $("#congress-message-tool").hide()
        $("#thank-you").show();
      } else if (data.responseText) {
        show_error(data.responseText, $form);
      } else {
        show_error("Something went wrong. Please try again later.", $form);
      }
    }
  });

  function show_error(error, form) {
    form.find(".progress-striped").hide();
    form.find("input[type=submit]").show();
    form.find(".alert-danger").remove();
    $("#errors").append($('<div class="small alert alert-danger help-block">').text(error));
    $("input,textarea,button,select", form).removeAttr("disabled");
  }
});
