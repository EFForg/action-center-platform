$(document).on("ready", function() {
  $("form.newsletter-subscription").on("ajax:beforeSend", function() {
  });

  $("form.newsletter-subscription").on("ajax:complete", function(xhr, data, status) {
    if (status == "success") {
      $(this).find(".radio-inline, input").attr("disabled", true);
      $(this).find("input, .radio-inline").css("opacity", 0.5);
      $(this).find("input[type=submit]").css("background-color", "#337ab7").val("Subscribed!");
      $(this).find(".privacy-notice-header em").text("Thanks for signing up!");
    }
  });

  $("form.newsletter-subscription input").attr("disabled", null);
});
