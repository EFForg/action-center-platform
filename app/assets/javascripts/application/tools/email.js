$(document).on('ready', function() {
  var dnt = false;
  $('#target-email .email-action').click(function(){
    // Set DNT to true after submission so we don't track subsequent submits.
    // We need this timeout so the value isn't changed before submission.
    setTimeout(function() {
      if (!dnt) { $('input[name="dnt"]').val('true'); }
      dnt = true;
    }, 0);
  });

  $('#target-email button').on('click', function() {
    $('.thank-you').show();
    $('#email-tool').hide();
  });

  $("#state-email-tool").on("ajax:beforeSend", function() {
    show_progress_bars();
  });

  $(".state-rep-lookup").on("ajax:complete", function(xhr, data, status) {
    var $form = $(this);
    if (status == "success") {
      if ($("#action-content").length) {
        $(window).scrollTop( $("#action-content").offset().top ); // go to top of page if on action center site
      }
      update_tabs(1, 2);
      $(".progress-striped").hide();
      $(".address-lookup").remove();
    } else if (data.responseText) {
      show_error(data.responseText, $form);
    } else {
      show_error("Something went wrong. Please try again later.", $form);
    }
  });
});
