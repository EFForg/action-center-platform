(function($) {
  $(function(){

    function get_query_string() {
      var result = {}, 
        query_string = location.search.substring(1), 
        re = /([^&=]+)=([^&]*)/g, 
        m;  
      while(m = re.exec(query_string)) {
        result[decodeURIComponent(m[1])] = decodeURIComponent(m[2]);
      }
      return result;
    }

    var support_whyb = get_query_string()['support_whyb'] ? true : false;
    var social = get_query_string()['social'] ? true : false;

    if(support_whyb || (Drupal.settings.eff_whyb && Drupal.settings.eff_whyb.html)) {
      var link;
      if (social) {
        link = 'https://supporters.eff.org/donate/who-has-your-back-s';
      }
      else if (support_whyb) {
        link = 'https://supporters.eff.org/donate/who-has-your-back';
      }
      else {
        link = Drupal.settings.eff_whyb.link;
      }
      var $bar = $('<a id="support-whyb"></a>')
        .attr('href', link)
        .html(Drupal.settings.eff_whyb.html);
      var $css = $('<style>a:link#support-whyb, a:visited#support-whyb { font-size: 12px; position: fixed; text-align: center; top: 0; z-index: 10; display: block; background-color: #333333; color: #aaaaaa; width: 90%; padding: 10px 5%; line-height: 150%; text-decoration: none; } a:hover#support-whyb { background-color: #666666; color: #ffffff; text-decoration: none; } @media screen and (max-device-width: 40em), screen and (max-width: 40em) { a:link#support-whyb, a:visited#support-whyb { display: none; } }</style>');
      $('body').append($bar).append($css);
      if ($('#support-whyb').is(':visible')) {
        $('body').css('padding-top', $('#support-whyb').height()+'px');
      }
    }

  });
})(jQuery);
;
;
(function ($) {

Drupal.behaviors.mytube = {
  attach: function (context, settings) {
    $('.mytubetrigger', context).once('mytubetrigger').click(function(){
      $(this).hide();
      $(this).after(unescape($('.mytubeembedcode', this).html()));
      Drupal.attachBehaviors(this);

      // If API usage is enabled, instantiate the API.
      if ($(this).hasClass('mytube-js-api')) {
        Drupal.behaviors.mytube.InitiateYouTubeAPI();
      }

    });

    // Start the video when pressing the Enter button
    $('.mytubetrigger', context).keypress(function(e){
      if(e.which == 13){ // Enter key pressed
        $(this).click(); // Trigger search button click event
      }
    });

  }
};

/**
 * If API usage is enabled, initalize the player once the API is ready.
 */
Drupal.behaviors.mytube.InitiateYouTubeAPI = function(context) {
  if (typeof this.initialized === 'undefined') {
    // Load the iFrame Player API code asynchronously.
    var tag = document.createElement('script');
    tag.src = "https://www.youtube.com/iframe_api";
    var firstScriptTag = document.getElementsByTagName('script')[0];
    firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
    this.initialized = true;
  }
};

})(jQuery);
;
/* eslint-disable no-multi-str */

(function ($) {

  'use strict';

  /**
   * The recommended way for producing HTML markup through JavaScript is to write
   * theming functions. These are similiar to the theming functions that you might
   * know from 'phptemplate' (the default PHP templating engine used by most
   * Drupal themes including Omega). JavaScript theme functions accept arguments
   * and can be overriden by sub-themes.
   *
   * In most cases, there is no good reason to NOT wrap your markup producing
   * JavaScript in a theme function.
   *
   * @param {string} path
   *   The link URL.
   * @param {string} title
   *   The link title.
   *
   * @return {jQuery}
   *   The anchor element.
   */
  Drupal.theme.prototype.badgerExampleButton = function (path, title) {
    // Create an anchor element with jQuery.
    return $('<a href="' + path + '" title="' + title + '">' + title + '</a>');
  };

  // Anchor above the header, not at the FAQ item
  function raiseAnchors() {
    if (window.location.hash) {
      window.scrollTo(window.scrollX, window.scrollY - 95);
    }
  }

  $(window).on('hashchange', function () {
    raiseAnchors();
  });

  /**
   * Behaviors are Drupal's way of applying JavaScript to a page. In short, the
   * advantage of Behaviors over a simple 'document.ready()' lies in how it
   * interacts with content loaded through Ajax. Opposed to the
   * 'document.ready()' event which is only fired once when the page is
   * initially loaded, behaviors get re-executed whenever something is added to
   * the page through Ajax.
   *
   * You can attach as many behaviors as you wish. In fact, instead of overloading
   * a single behavior with multiple, completely unrelated tasks you should create
   * a separate behavior for every separate task.
   *
   * In most cases, there is no good reason to NOT wrap your JavaScript code in a
   * behavior.
   *
   * @param context
   *   The context for which the behavior is being executed. This is either the
   *   full page or a piece of HTML that was just added through Ajax.
   * @param settings
   *   An array of settings (added through drupal_add_js()). Instead of accessing
   *   Drupal.settings directly you should use this because of potential
   *   modifications made by the Ajax callback that also produced 'context'.
   */
  Drupal.behaviors.badgerDownload = {
    attach: function (context, settings) {
      // By using the 'context' variable we make sure that our code only runs on
      // the relevant HTML. Furthermore, by using jQuery.once() we make sure that
      // we don't run the same piece of code for an HTML snippet that we already
      // processed previously. By using .once('foo') all processed elements will
      // get tagged with a 'foo-processed' class, causing all future invocations
      // of this behavior to ignore them.
      $('#badger-download', context).once('badger-download', function () {
        var firefox_url = $('#badger-firefox').attr('href');
        var chrome_url = $('#badger-chrome').attr('href');
        var opera_url = $('#badger-opera').attr('href');

        // detect browser
        var browser = 'other';
        if (navigator && navigator.userAgent) {
          if (navigator.userAgent.match(/Android/i)) {
            browser = 'android';
          }
          else if (navigator.userAgent.match(/firefox/i)) {
            browser = 'firefox';
          }
          else if (navigator.userAgent.match(/OPR|opera/i)) {
            browser = 'opera';
          }
          else if (navigator.userAgent.match(/edge/i)) {
            browser = 'edge';
          }
          else if (navigator.userAgent.match(/chrome/i)) {
            browser = 'chrome';
          }
          else if (navigator.userAgent.match(/iPhone/i)) {
            browser = 'iphone';
          }
          else {
            browser = 'other';
          }
        }

        // [Install Privacy Badger and enable do not track]

        // build the links
        function install_link(browser, url) {
          var $install = $('<a></a>')
            .attr('href', url)
            .html(Drupal.t('Install Privacy Badger') + '<br><div>' + Drupal.t('and Enable Do Not Track') + '</div>');

          return $install;
        }

        function other_link(browser, url) {
          var $other = $('<a></a>')
            .attr('href', url)
            .html(Drupal.t('Install for !browser', {'!browser': browser}));
          return $('<p class="browser-other-link '+browser+'"></p>').append($other);
        }

        function changelog_link() {
          var url = Drupal.settings.privacyBadger.changelog;
          var version = Drupal.settings.privacyBadger.version;
          var $link = $('<a></a>')
            .attr('href', url)
            .html(Drupal.t('v' + version));
          return $('<p id="badger-version"></p>').append($link);
        }


        $('#badger-download').empty();
        // firefox
        if (browser === 'firefox') {
          $('#badger-download')
            .click(function () { window.location = firefox_url; })
            .append(install_link('Firefox', firefox_url))
            .after(other_link('Firefox on Android', firefox_url))
            .after(other_link('Chrome', chrome_url))
            .after(other_link('Opera', opera_url))
            .after(changelog_link());
        }
        // chrome
        else if (browser === 'chrome') {
          $('#badger-download')
            .click(function() {  window.location = chrome_url; })
            .append(install_link('Chrome', chrome_url))
            .after(other_link('Firefox on Android', firefox_url))
            .after(other_link('Firefox', firefox_url))
            .after(other_link('Opera', opera_url))
            .after(changelog_link());
        }
        // opera
        else if (browser === 'opera') {
          $('#badger-download')
            .click(function () { window.location = opera_url; })
            .append(install_link('Opera', opera_url))
            .after(other_link('Firefox on Android', firefox_url))
            .after(other_link('Chrome', chrome_url))
            .after(other_link('Firefox', firefox_url))
            .after(changelog_link());
        }
        // android
        else if (browser === 'android') {
          $('#badger-download')
            .click(function () { window.location = firefox_url; })
            .append(install_link('Firefox', firefox_url))
            .after(Drupal.t('<div><em>Privacy Badger for Firefox on Android is in BETA.</em></div>'));
        }
        // iPhone
        else if (browser === 'iphone') {
          $('#badger-download')
            .append('Browser Not Supported').addClass("not-supported")
            .after(Drupal.t('<div class="badger-download-mobile">We don\'t yet have a version of Privacy Badger for iOS. \
              You can <a href="https://itunes.apple.com/us/app/brave-web-browser/id1052879175">Install Brave</a>, which is a great browser \
              with built in tracker blocking, or <a href="https://itunes.apple.com/us/app/disconnect-pro-privacy-and-performance/id1057771839">Install Disconnect Pro</a> \
              an app that does OS-wide tracker blocking. <span class="badger-download-mobile-tiny">These apps are made by third parties, not EFF. \
              You can read <a href="https://www.brave.com/ios_privacy.html" target="_blank">Brave\'s privacy policy</a> and \
              <a href="https://disconnect.me/privacy" target="_blank">Disconnect\'s privacy policy</a>.</span></div>'));
        }
        // unsupported browser
        else {
          $('#badger-download')
            .append('Browser Not Supported').addClass("not-supported")
            .after(Drupal.t('<div class="badger-download-mobile">Privacy Badger is not supported in this browser. <a href="https://www.eff.org/privacybadger/faq#Will-you-be-supporting-any-other-browsers-besides-Chrome-/-Firefox-/-Opera">(More info)</a></div>'));
        }
      });
    }
  };

  Drupal.behaviors.badgerFaqRedirects = {
    attach: function (context, settings) {
      if (window.location.hash != "") {
          var path = window.location.pathname + encodeURIComponent(window.location.hash);
          switch(path) {
            case '/privacybadger%23faq-What-is-Privacy-Badger%3F':
              window.location.replace('/privacybadger/faq#What-is-Privacy-Badger');
              break;
            case "/privacybadger%23faq-How-is-Privacy-Badger-different-from-Disconnect%2C-Adblock-Plus%2C-Ghostery%2C-and-other-blocking-extensions%3F":
              window.location.replace("/privacybadger/faq#How-is-Privacy-Badger-different-from-Disconnect,-Adblock-Plus,-Ghostery,-and-other-blocking-extensions");
              break;
            case "/privacybadger%23faq-How-does-Privacy-Badger-work%3F":
              window.location.replace("/privacybadger/faq#How-does-Privacy-Badger-work");
              break;
            case "/privacybadger%23faq-What-is-a-third-party-tracker%3F":
              window.location.replace("/privacybadger/faq#What-is-a-third-party-tracker");
              break;
            case "/privacybadger%23faq-What-do-the-red%2C-yellow-and-green-sliders-in-the-Privacy-Badger-menu-mean%3F":
              window.location.replace("/privacybadger/faq#What-do-the-red,-yellow-and-green-sliders-in-the-Privacy-Badger-menu-mean");
              break;
            case "/privacybadger%23faq-Why-does-Privacy-Badger-block-ads%3F":
              window.location.replace("/privacybadger/faq#Why-does-Privacy-Badger-block-ads");
              break;
            case "/privacybadger%23faq-Why-doesn't-Privacy-Badger-block-all-ads%3F":
              window.location.replace("/privacybadger/faq#Why-doesn't-Privacy-Badger-block-all-ads");
              break;
            case "/privacybadger%23faq-What-about-tracking-by-the-sites-I-actively-visit%2C-like-NYTimes.com-or-Facebook.com%3F":
              window.location.replace("/privacybadger/faq#What-about-tracking-by-the-sites-I-actively-visit,-like-NYTimes.com-or-Facebook.com");
              break;
            case "/privacybadger%23faq-Does-Privacy-Badger-contain-a-%2522black-list%2522-of-blocked-sites%3F":
              window.location.replace('/privacybadger/faq#Does-Privacy-Badger-contain-a-"black-list"-of-blocked-sites');
              break;
            case "/privacybadger%23faq-How-was-the-cookie-blocking-yellowlist-created%3F":
              window.location.replace("/privacybadger/faq#How-was-the-cookie-blocking-yellowlist-created");
              break;
            case "/privacybadger%23faq-Does-Privacy-Badger-prevent-fingerprinting%3F":
              window.location.replace("/privacybadger/faq#Does-Privacy-Badger-prevent-fingerprinting");
              break;
            case "/privacybadger%23faq-Does-Privacy-Badger-consider-every-cookie-to-be-a-tracking-cookie%3F":
              window.location.replace("/privacybadger/faq#Does-Privacy-Badger-consider-every-cookie-to-be-a-tracking-cookie");
              break;
            case "/privacybadger%23faq-Does-Privacy-Badger-account-for-a-cookie-that-was-used-to-track-me-even-if-I-deleted-it%3F":
              window.location.replace("/privacybadger/faq#Does-Privacy-Badger-account-for-a-cookie-that-was-used-to-track-me-even-if-I-deleted-it");
              break;
            case "/privacybadger%23faq-Does-Privacy-Badger-still-work-when-blocking-third-party-cookies-in-the-browser%3F":
              window.location.replace("/privacybadger/faq#Does-Privacy-Badger-still-work-when-blocking-third-party-cookies-in-the-browser");
              break;
            case "/privacybadger%23faq-Will-you-be-supporting-any-other-browsers-besides-Chrome-%2F-Firefox-%2F-Opera%3F":
              window.location.replace("/privacybadger/faq#Will-you-be-supporting-any-other-browsers-besides-Chrome-/-Firefox-/-Opera");
              break;
            case "/privacybadger%23faq-Can-I-download-Privacy-Badger-outside-of-the-Chrome-Web-Store%3F":
              window.location.replace("/privacybadger/faq#Can-I-download-Privacy-Badger-outside-of-the-Chrome-Web-Store");
              break;
            case "/privacybadger%23faq--I-am-an-online-advertising-%2F-tracking-company.--How-do-I-stop-Privacy-Badger-from-blocking-me%3F":
              window.location.replace("/privacybadger/faq#-I-am-an-online-advertising-/-tracking-company.--How-do-I-stop-Privacy-Badger-from-blocking-me");
              break;
            case "/privacybadger%23faq-What-is-the-Privacy-Badger-license%3F--Where-is-the-Privacy-Badger-source-code%3F":
              window.location.replace("/privacybadger/faq#What-is-the-Privacy-Badger-license--Where-is-the-Privacy-Badger-source-code");
              break;
            case "/privacybadger%23faq-I-found-a-bug!-What-do-I-do-now%3F":
              window.location.replace("/privacybadger/faq#I-found-a-bug!-What-do-I-do-now");
              break;
            case "/privacybadger%23faq-How-can-I-support-Privacy-Badger%3F":
              window.location.replace("/privacybadger/faq#How-can-I-support-Privacy-Badger");
              break;
            case "/privacybadger%23faq-How-does-Privacy-Badger-handle-social-media-widgets%3F":
              window.location.replace("/privacybadger/faq#How-does-Privacy-Badger-handle-social-media-widgets");
              break;
            case "/privacybadger%23faq-How-do-I-uninstall%2Fremove-Privacy-Badger%3F":
              window.location.replace("/privacybadger/faq#How-do-I-uninstall/remove-Privacy-Badger");
              break;
            case "/privacybadger%23faq-Is-Privacy-Badger-compatible-with-other-extensions%2C-including-other-adblockers%3F":
              window.location.replace("/privacybadger/faq#Is-Privacy-Badger-compatible-with-other-extensions,-including-other-adblockers");
              break;
            case "/privacybadger%23faq-Why-does-my-browser-connect-to-fastly.com-IP-addresses-on-startup-after-installing-Privacy-Badger%3F":
              window.location.replace("/privacybadger/faq#Why-does-my-browser-connect-to-fastly.com-IP-addresses-on-startup-after-installing-Privacy-Badger");
              break;
            case "/privacybadger%23faq-Why-am-I-getting-a-%2522This-extension-failed-to-redirect-a-network-request-to-...%2522-warning-in-Chrome%3F":
              window.location.replace('/privacybadger/faq#Why-am-I-getting-a-"This-extension-failed-to-redirect-a-network-request-to-..."-warning-in-Chrome');
              break;
            case "/privacybadger%23faq-Why-isn't-my-Badger-learning-to-block-anything%3F":
              window.location.replace("/privacybadger/faq#Why-isn't-my-Badger-learning-to-block-anything");
              break;
        }
      }
    }
  };

})(jQuery);
;
/**
 * @file
 * JavaScript integrations between the Caption Filter module and particular
 * WYSIWYG editors. This file also implements Insert module hooks to respond
 * to the insertion of content into a WYSIWYG or textarea.
 */
(function ($) {

$(document).bind('insertIntoActiveEditor', function(event, options) {
  if (options['fields']['title'] && Drupal.settings.captionFilter.widgets[options['widgetType']]) {
    options['content'] = '[caption caption="' + options['fields']['title'].replace(/"/g, '\\"') + '"]' + options['content'] + '[/caption]';
  }
});

Drupal.captionFilter = Drupal.captionFilter || {};

Drupal.captionFilter.toHTML = function(co, editor) {
  return co.replace(/(?:<p>)?\[caption([^\]]*)\]([\s\S]+?)\[\/caption\](?:<\/p>)?[\s\u00a0]*/g, function(a,b,c){
    var id, cls, w, tempClass;

    b = b.replace(/\\?'|\\&#39;|\\&#039;/g, '&#39;').replace(/\\"|\\&quot;/g, '&quot;');
    c = c.replace(/\\&#39;|\\&#039;/g, '&#39;').replace(/\\&quot;/g, '&quot;');
    id = b.match(/id=['"]([^'"]+)/i);
    cls = b.match(/align=['"]([^'"]+)/i);
    ct = b.match(/caption=['"]([^'"]+)/i);
    w = c.match(/width=['"]([0-9]+)/);

    id = ( id && id[1] ) ? id[1] : '';
    cls = ( cls && cls[1] ) ? 'caption-' + cls[1] : '';
    ct = ( ct && ct[1] ) ? ct[1].replace(/\\\\"/,'"') : '';
    w = ( w && w[1] ) ? parseInt(w[1])+'px' : 'auto';

    if (editor == 'tinymce')
      tempClass = (cls == 'caption-center') ? 'mceTemp mceIEcenter' : 'mceTemp';
    else if (editor == 'ckeditor')
      tempClass = (cls == 'caption-center') ? 'mceTemp mceIEcenter' : 'mceTemp';
    else
      tempClass = '';

    if (ct) {
      return '<div class="caption ' + cls + ' ' + tempClass + ' draggable"><div class="caption-width-container" style="width: ' + w + '"><div class="caption-inner">' + c + '<p class="caption-text">' + ct + '</p></div></div></div><br />';
    }
    else {
      return '<div class="caption ' + cls + ' ' + tempClass + ' draggable"><div class="caption-width-container" style="width: ' + w + '"><div class="caption-inner">' + c + '</div></div></div><br />';
    }
  });
};

Drupal.captionFilter.toTag = function(co) {
  return co.replace(/(<div class="caption [^"]*">)\s*<div[^>]+>\s*<div[^>]+>(.+?)<\/div>\s*<\/div>\s*<\/div>\s*/gi, function(match, captionWrapper, contents) {
    var align;
    align = captionWrapper.match(/class=.*?caption-(left|center|right)/i);
    align = (align && align[1]) ? align[1] : '';
    caption = contents.match(/\<p class=\"caption-text\"\>(.*)\<\/p\>/);
    caption_html = (caption && caption[0]) ? caption[0] : '';
    caption = (caption && caption[1]) ? caption[1].replace(/"/g, '\\"') : '';
    contents = contents.replace(caption_html, '');

    return '[caption' + (caption ? (' caption="' + caption + '"') : '') + (align ? (' align="' + align + '"') : '') + ']' + contents + '[/caption]';
  });
};

})(jQuery);
;
