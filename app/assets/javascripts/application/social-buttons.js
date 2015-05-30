$(document).on('ready', function () {
    /* ==========================================================================
       Social counts
       ========================================================================== */

    var shareUrl = window.location.href;
    // If the share buttons widget is visible, lets load some values
    if($('#share-buttons').length > 0) {
        $.ajax('/tools/social_buttons_count?url=' + shareUrl, {
            success: function(res, err) {
                $.each(res, function(network, value) {
                    var count = value;
                    if (count / 10000 > 1) {
                        count = Math.ceil(count / 1000) + 'k'
                    }
                    $('[data-network="' + network + '"]').attr('count', count).hide().show();
                })
            },
            dataType: 'json',
            cache         : true
        });

        $( ".facebook-button" ).click(function() {
          var url = $(this).attr("href");
          window.open(url, "Share on Facebook", "width=650,height=500");
          return false;
        })
        $( ".twitter-button" ).click(function() {
            var url = $(this).attr("href");
            window.open(url,"Twitter","width=550,height=420");
            return false;
        })
        $( ".google-button" ).click(function() {
            var url = $(this).attr("href");
            window.open(url,"Share on Google Plus","width=500,height=436");
            return false;
        })
    }

});
