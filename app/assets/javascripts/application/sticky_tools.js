//= require bootstrap/affix

$(function() {
  var s = $('#tools');
  var t = $('.top-section .row');
  if (s.length > 0 && t.length > 0) {
    var originalTop = $('.top-section .row').offset().top,
        currentTop = originalTop,
        topSpacing = 10,
        bottomSpacing = 200,
        $window = $(window),
        $document = $(document),
        windowHeight = $window.height();

    function scroller() {
      var scrollTop = $window.scrollTop(),
          documentHeight = $document.height(),
          dwh = documentHeight - windowHeight,
          extra = (scrollTop > dwh) ? dwh - scrollTop : 0;

      var etse = t.offset().top + topSpacing - extra;

      s.parent().css('height', s.height());
      if (s.css('position') !== 'fixed') {
        s.css('top', '');
        s.parent().css('height', 'auto');
      } else if (scrollTop <= etse || windowHeight < s.find('.tool').first().outerHeight()) {
        var newTop = etse - scrollTop;
      } else {
        var newTop = documentHeight - s.outerHeight() - topSpacing - bottomSpacing - scrollTop - extra;
        if (newTop < 0) {
          newTop = newTop + topSpacing;
        } else {
          newTop = topSpacing;
        }
      }
      if (newTop && currentTop != newTop) {
        s.css('top', newTop);
        currentTop = newTop;
      }
    }

    function resizer() {
      windowHeight = $window.height();
    }

    window.scroller = scroller;
    window.resizer = resizer;

    if (window.addEventListener) {
      window.addEventListener('scroll', scroller, false);
      window.addEventListener('resize', resizer, false);
    } else if (window.attachEvent) {
      window.attachEvent('onscroll', scroller);
      window.attachEvent('onresize', resizer);
    }
    scroller();
  }
});
