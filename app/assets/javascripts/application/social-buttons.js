$(document).on('ready', function() {
  /* ==========================================================================
     Social counts
     ========================================================================== */

  var shareUrl = window.location.href;
  // If the share buttons widget is visible, lets load some values
  if ($('#share-buttons').length > 0) {
    $(".facebook-button").click(function() {
      var url = $(this).attr("href");
      window.open(url, "Share on Facebook", "width=650,height=500");
      return false;
    })
    $(".twitter-button").click(function() {
      var url = $(this).attr("href");
      window.open(url, "Twitter", "width=550,height=420");
      return false;
    })
  }

});
