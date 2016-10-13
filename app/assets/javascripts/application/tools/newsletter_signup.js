$(document).on("ready", function() {
  $("form.newsletter-subscription").on("ajax:beforeSend", function() {
  });

  $("form.newsletter-subscription").on("ajax:complete", function(xhr, data, status) {
    if (status == "success") {
      $(this).addClass("submitted");
      $(this).find("input").attr("disabled", true);
      $(this).find("input[type=submit]").val("Subscribed!");
      $(this).find(".privacy-notice-header em").text("Thanks for signing up!");
      $(this).attr("data-signed-up-for-mailings", "true");
    }
  });

  $("form.newsletter-subscription input").attr("disabled", null);

  $("input[type=radio][name=subscribe]").on("change", function() {
    var form = $(this).parents("form");
    var subscribe = form.find("input[name=subscribe]:checked").val() == "1";
    var emailField = form.find("input[name=subscription\\[email\\]]");
    emailField.attr("required", subscribe ? "required" : null);
  });

  $("input[name=subscribe]:checked").each(function() {
    var subscribe = $(this).val() == "1";
    var emailField = $("input[name=subscription\\[email\\]]");
    emailField.attr("required", subscribe ? "required" : null);
  });
});

