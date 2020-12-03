// tweet.js
// Code here is relevant to tweet actions

$(document).on('ready', function() {

  // Button "Look up your reps"
  $('form.tweet-tool').on('submit', function(ev) {
    var form = $(ev.currentTarget);

    replaceSubmitButtonWithProgressBar();

    lookupTweetTargets(form.find("#street_address").val(),
                       form.find("#zipcode").val());
    return false;

    function replaceSubmitButtonWithProgressBar() {
      form.find(".progress-striped").show();
      form.find("input[type=submit]").hide();
      height_changed();
    }

    function show_address_error(error) {
      form.find(".progress-striped").hide();
      form.find("input[type=submit]").show();
      form.find('.alert-danger').remove();
      form.prepend($('<div class="small alert alert-danger help-block">').text(error));
      height_changed();
    }

    function lookupTweetTargets(street, zipcode) {
      $.ajax({
        url: "/tools/reps",
        data: { street_address: street, zipcode: zipcode },
        success: function(data) {
          if (data.content)
            populateTweetTargets(data);
          else if (data.error)
            show_address_error(data.error);
          else
            show_address_error("An unknown error occured.");
        },
        error: function(er) {
          show_address_error(er.statusText);
        }
      });
    }

    // Sets the view up to show tweet targets based on data retrieved from /tools/reps
    function populateTweetTargets(data) {
      $('#tweet-tool-container').show();
      form.replaceWith($(data.content));
      $('#tweet-message-wrapper').show();
      $('.twitter-tool-label').show();
      $('.privacy-notice').hide();
      $('.call-to-sign-up').fadeIn(500);
      height_changed();
    }

  });


  $(document).on('click', '.btn-tweet', function(e) {
    var action_id = $('[data-action-id]').attr('data-action-id');
    $.ajax({ url: '/tools/tweet?action_id=' + action_id, type: 'POST' });

    var btn = $(e.target);
    var msg = $('#tweet-message-wrapper textarea');
    if (msg.length > 0) {
      btn.attr('href', "https://twitter.com/intent/tweet?related=eff&text=" +
               "." +
               btn.data('twitter-id') +
               "%20" +
               encodeURIComponent(msg.val()));
    }
    Twitter.handleIntent(e);
    $('#tweet-tool').hide();
    $('.thank-you').show();
  });

  $('#tweet-back').on('click', function(){
    $('#tweet-tool').show();
    $('.thank-you').hide();
  });

  var related = $("#tweet-tool").data("tweet-related");
  var message = $("#tweet-tool").data("tweet-message");
  var targets = $("#tweet-tool").data("tweet-targets");

  $(".tweet-refresh").on("click", function() {
    var targets = $("#tweet-tool-container .tweet-individual");
    var display_num = targets.filter(":visible").length;
    targets = _.sample($.makeArray(targets), display_num);

    $(".tweet-individual").hide();
    $(targets).show();
  });
});
