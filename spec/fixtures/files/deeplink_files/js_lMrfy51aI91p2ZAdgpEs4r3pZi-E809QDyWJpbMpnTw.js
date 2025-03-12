(function ($) {

  'use strict';

  Drupal.behaviors.piwikNoscript = {
    attach: function (context, settings) {
      $('#piwik-noscript', context).once('piwik-noscript', function () {
        $(this).html(Drupal.theme('piwikNoscriptImage', settings.piwikNoscript.image));
      });
    }
  };

  Drupal.theme.prototype.piwikNoscriptImage = function (image) {
    // Define some parameters in the image src attribute.
    return image
      .replace('urlref=', 'urlref=' + encodeURIComponent(document.referrer))
      .replace('action_name=', 'action_name=' + encodeURIComponent(document.title));
  };

}(jQuery));
;
