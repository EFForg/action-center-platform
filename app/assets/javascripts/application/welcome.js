
$(document).ready(function() {
  // Make each of the "more actions" sections the same height.
  var equalheight = function(container) {
    var currentTallest = 0,
        currentRowStart = 0,
        rowDivs = new Array(),
        $el,
        topPosition = 0;

    $(container).each(function() {
      $el = $(this);
      $($el).height('auto')
      topPostion = $el.position().top;

      if (currentRowStart != topPostion) {
        for (currentDiv = 0; currentDiv < rowDivs.length; currentDiv++) {
          rowDivs[currentDiv].height(currentTallest);
        }
        rowDivs.length = 0; // empty the array
        currentRowStart = topPostion;
        currentTallest = $el.height();
        rowDivs.push($el);
      } else {
        rowDivs.push($el);
        currentTallest = (currentTallest < $el.height()) ? ($el.height()) : (currentTallest);
      }
      for (currentDiv = 0; currentDiv < rowDivs.length; currentDiv++) {
        rowDivs[currentDiv].height(currentTallest);
      }
    });
  };

  $(window).load(function() {
    equalheight('.more-actions');
  });

  $(window).resize(function() {
    equalheight('.more-actions');
  });

  // Email subscription form submit
  var subscription = {
    beforeSend: function() {
      $(this).hide();
      return $('.progress-striped').show();
    },
    complete: function(xhr, data, status) {
      $('.progress-striped').hide();
      var message;
      if (status === "success")
        message = App.Strings.successfulEmailSubmission;
      else if (data.responseJSON.message)
        message = data.responseJSON.message;
      else
        message = App.Strings.failedEmailSubmission;
      return $("<p>").text(message).insertAfter(this);
    }
  };

  $('#subscription-form').bind('ajax:beforeSend', subscription.beforeSend);
  $('#subscription-form').bind('ajax:complete', subscription.complete);
});
