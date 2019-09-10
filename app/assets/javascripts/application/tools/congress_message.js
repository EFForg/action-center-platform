$(document).on("ready", function() {
  if ($("#congress-message-tool").length){  // showing paging at top of form
    $(".page-indicator").css("display", "grid");
  }

  $("#congress-message-tool").on("ajax:beforeSend", function() {
    show_progress_bars();
  });

  $(".congress-message-rep-lookup").on("ajax:complete", function(xhr, data, status) {
    var $form = $(this);
    if (status == "success") {
      update_tabs(1, 2);
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

  $("#congress-message-tool").on("click", "#to-page-3", function(){
    $(".rep-info").hide();
    $("#customize-message").show();
    update_tabs(2, 3);
  });

  $(".congress-message-tool-container").on("click", "#customize-message :submit", function(e){
    // Can't use rails remote: true because the form is rendered dynamically
    e.preventDefault();
    var $form = $("#congress-message-create");
    $.ajax({
      type: "POST",
      url: $form.attr("action"),
      data: $form.serialize(),
      beforeSend: show_progress_bars(),
      success: function(data) {
        $("#congress-message-create").hide();
        $("#congress-message-tool").hide();
        $('.thank-you').show();
        update_tabs(3, 4);
      },
      error: function(data) {
        if (data.responseText) {
          // Go back to page 2, show errors
          $("#customize-message").hide();
          $(".rep-info").show();
          update_tabs(3, 2);
          show_error(data.responseText, $form);
        } else {
          show_error("Something went wrong. Please try again later.", $form);
        }
      }
    });
  });

  function show_progress_bars() {
    $(".progress-striped").show();
    $(":submit").hide();
    $("input,textarea,button,select", $(this)).attr("disabled", "disabled");
  }

  function show_error(error, form) {
    form.find(".progress-striped").hide();
    form.find(":submit").show();
    form.find(".alert-danger").remove();
    $("#errors").append($('<div class="small alert alert-danger help-block">').text(error));
    $("input,textarea,button,select", form).removeAttr("disabled");
  }

  function update_tabs(from, to) {
    $(".page-indicator div.page" + from).css({
      'background-color': '#2D2D2D',
      'color': '#BABABA'
    });
    $(".page-indicator div.page" + to).css({
      'background-color': '#BABABA',
      'color': '#2D2D2D'
    });
  }
});
