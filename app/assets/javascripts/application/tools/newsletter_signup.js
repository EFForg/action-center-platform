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

$(".signup-radios input").on("change", function() {
  // Check if the user is signing up for any newsletter within this form.
  var form = $(this).parents("form");
  var subscribe = form.find(".signup-radios input[value=1]:checked").length > 0;
  var emailField = form.find("#subscription_email");
  emailField.attr("placeholder", subscribe? "Email" : "Email (optional)");
  emailField.attr("required", subscribe ? "required" : null);
});

// Set the initial required state of the email signup form.
// (We can't do this is the view because of no-js users)
$(".signup-radios input:checked").trigger("change");

// Show a random e-mail signup (ours or an action partner's) on each tool
$.fn.random = function() {
  return this.eq(Math.floor(Math.random() * this.length));
}
$('.tool').each(function() {
  $(this).find('.email-signup').hide().random().show();
});

