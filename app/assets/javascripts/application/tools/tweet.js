// tweet.js
// Code here is relevant to tweet actions

$(document).on('ready', function() {

  // Button "Look up your reps"
  $('form.tweet-tool').on('submit', function(ev) {
    var form = $(ev.currentTarget);

    replaceSubmitButtonWithProgressBar();

    // lookup latitude and longitude
    SmartyStreets.street_address({ street: form.find("#street_address").val(),
                                   zipcode: form.find("#zipcode").val() })
      .done(lookupTweetTargets)
      .error(show_address_error);

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

    // hits /tools/reps to look up representatives exposed via Sunlight API
    function lookupTweetTargets(smartyStreetsData){
      if(smartyStreetsData.length > 0) { // if we had a valid address
        var lat = smartyStreetsData[0].metadata.latitude,
            lon = smartyStreetsData[0].metadata.longitude,
            url = '/tools/reps?lat=' + lat + '&lon=' + lon;

        $.ajax({ url: url, type: 'GET'})
          .done(function(data) {
            if (data.content)
              populateTweetTargets(data);
            else if (data.error)
              show_address_error(data.error);
            else
              show_address_error("An unknown error occured.");
          })
          .fail(function(er) {
            show_address_error(er.statusText);
          });
      } else {
        show_address_error(App.Strings.addressLookupFailed);
      }
    }

    // Sets the view up to show tweet targets based on data retrieved from
    // sunlight API
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
    var msg = $('#tweet-message');
    if (msg.length > 0) {
      btn.attr('href', "https://twitter.com/intent/tweet?related=eff&status=" +
        "." + btn.data('twitter-id') + "%20" + encodeURIComponent(msg.val()));
    }
    Twitter.handleIntent(e);
  });

  if(typeof targets != "undefined"){
    var display_num = 3;
    display_random_targets(display_num);
  }

  function display_random_targets(display_num){
    var random_targets = _.sample(targets, display_num);
    var refresh_button = "";

    if(targets.length > display_num){
      var refresh_button = JST['application/templates/tweet_refresh_button']({display_num: display_num});
    }

    $('#tweet-tool-container').html(_.map(random_targets, function(target){
      return JST['application/templates/tweet_individual'](_.extend({
        message: encodeURIComponent(message),
        related: related
      }, target));
    }).join("") + refresh_button);
    height_changed();

    $(".tweet-refresh").on('click', function(){
      display_random_targets(display_num);
    });
  }
});
