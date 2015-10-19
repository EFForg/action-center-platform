// Make each of the "more actions" sections the same height.

equalheight = function(container) {
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
  equalheight('.more-actions .col-md-4');
});


$(window).resize(function() {
  equalheight('.more-actions .col-md-4');
});


// Email subscription form submit

var subscription;

subscription = {
  beforeSend: function() {
    $(this).hide();
    return $('.progress-striped').show();
  },
  complete: function(xhr, data, status) {
    $('.progress-striped').hide();
    if(status === "success")
      return $(App.Strings.successfulEmailSubmission).insertAfter(this);
    else
      return $(App.Strings.invalidEmailSubmission).insertAfter(this);
  }
};

$(function() {
  return $('#subscription-form').bind('ajax:beforeSend', subscription.beforeSend);
});

$(function() {
  return $('#subscription-form').bind('ajax:complete', subscription.complete);
});
