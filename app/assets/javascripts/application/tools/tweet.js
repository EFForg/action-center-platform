$(document).on('ready', function() {
  $('form.tweet-tool').on('submit', function(ev) {
    var form = $(ev.currentTarget);

    function show_address_error(error) {
      form.find(".progress-striped").hide();
      form.find("input[type=submit]").show();
      form.find('.alert-danger').remove();
      form.prepend($('<div class="small alert alert-danger help-block">').text(error));
      height_changed();
    }

    function handle_smarty(smart_data){
      if(smart_data.length > 0) {
        var url = '/tools/reps?lat=' + smart_data[0].metadata.latitude + '&lon=' + smart_data[0].metadata.longitude;
        $.ajax({ url: url, type: 'GET'}).
          done(function(data) {
            if (data.content) {
              $('#tweet-tool-container').show();
              form.replaceWith($(data.content));
              $('#tweet-message-wrapper').show();
              $('.twitter-tool-label').show();
              $('.privacy-notice').hide();
              $('.call-to-sign-up').fadeIn(500);
              height_changed();
            } else if (data.error) {
              show_address_error(data.error);
            } else {
              show_address_error("An unknown error occured.");
            }
          }).fail(function(er) { show_address_error(er.statusText); });
      } else {
        show_address_error("We were unable to find a zip+4 for the address you entered.  Make sure you *only* entered your street address (without your city and state).  Please check and try again.");
      }
    }
    form.find(".progress-striped").show();
    form.find("input[type=submit]").hide();
    height_changed();
    SmartyStreets.street_address({
      street: form.find("#street_address").val(),
      street2: '',
      city: '',
      state: '',
      zipcode: form.find("#zipcode").val(),
      candidates: ''
    }).done(handle_smarty).
      error(show_address_error);
    return false;
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
