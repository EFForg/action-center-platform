$(document).on("ready", function() {
  $("#congress-message-tool").on("ajax:beforeSend", function() {
    $(".progress-striped").show();
    $("input[type=submit]").hide();
    $("input,textarea,button,select", $(this)).attr("disabled", "disabled");
  });
  $("#to-page-2").click(function(){  // show customize message
    $("#customize-message").show();
    $(".address-lookup").hide();
    $("#to-page-2").hide();
    $(".page-indicator div.page1").css({
      'background-color': '#2D2D2D',
      'color': '#BABABA'
    });
    $(".page-indicator div.page2").css({
      'background-color': '#BABABA',
      'color': '#2D2D2D'
    });
  });

  $("#to-page-3").click(function(){ // show representatives info
    $("#customize-message").hide();
    $("#to-page-3").hide();
    $(".page-indicator div.page2").css({
      'background-color': '#2D2D2D',
      'color': '#BABABA'
    });
    $(".page-indicator div.page3").css({
      'background-color': '#BABABA',
      'color': '#2D2D2D'
    });
  });

  $("#tools #congress-message-tool input[type='submit']:first-child").click(function(){ // show thank you
    $(".page-indicator div.page3").css({
      'background-color': '#2D2D2D',
      'color': '#BABABA'
    });
    $(".page-indicator div.page4").css({
      'background-color': '#BABABA',
      'color': '#2D2D2D'
    });
  });


  if ($("#congress-message-tool").length){  // showing paging at top of form
    $(".page-indicator").css("display", "grid");
  }



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
