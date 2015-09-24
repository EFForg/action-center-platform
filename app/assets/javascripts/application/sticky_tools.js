$(function() {
  var s = $('#tools');
  var t = $('.redtop .row');
  if (s.length > 0 && t.length > 0) {
    var originalTop = $('.redtop .row').offset().top,
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
    window.scroller = resizer;

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

// Bootstrap Affix.js
+function(e){"use strict";function n(n){return this.each(function(){var r=e(this);var i=r.data("bs.affix");var s=typeof n=="object"&&n;if(!i)r.data("bs.affix",i=new t(this,s));if(typeof n=="string")i[n]()})}var t=function(n,r){this.options=e.extend({},t.DEFAULTS,r);this.$target=e(this.options.target).on("scroll.bs.affix.data-api",e.proxy(this.checkPosition,this)).on("click.bs.affix.data-api",e.proxy(this.checkPositionWithEventLoop,this));this.$element=e(n);this.affixed=this.unpin=this.pinnedOffset=null;this.checkPosition()};t.VERSION="3.1.1";t.RESET="affix affix-top affix-bottom";t.DEFAULTS={offset:0,target:window};t.prototype.getPinnedOffset=function(){if(this.pinnedOffset)return this.pinnedOffset;this.$element.removeClass(t.RESET).addClass("affix");var e=this.$target.scrollTop();var n=this.$element.offset();return this.pinnedOffset=n.top-e};t.prototype.checkPositionWithEventLoop=function(){setTimeout(e.proxy(this.checkPosition,this),1)};t.prototype.checkPosition=function(){if(!this.$element.is(":visible"))return;var n=e(document).height();var r=this.$target.scrollTop();var i=this.$element.offset();var s=this.options.offset;var o=s.top;var u=s.bottom;if(typeof s!="object")u=o=s;if(typeof o=="function")o=s.top(this.$element);if(typeof u=="function")u=s.bottom(this.$element);var a=this.unpin!=null&&r+this.unpin<=i.top?false:u!=null&&i.top+this.$element.height()>=n-u?"bottom":o!=null&&r<=o?"top":false;if(this.affixed===a)return;if(this.unpin!=null)this.$element.css("top","");var f="affix"+(a?"-"+a:"");var l=e.Event(f+".bs.affix");this.$element.trigger(l);if(l.isDefaultPrevented())return;this.affixed=a;this.unpin=a=="bottom"?this.getPinnedOffset():null;this.$element.removeClass(t.RESET).addClass(f).trigger(e.Event(f.replace("affix","affixed")));if(a=="bottom"){this.$element.offset({top:n-this.$element.height()-u})}};var r=e.fn.affix;e.fn.affix=n;e.fn.affix.Constructor=t;e.fn.affix.noConflict=function(){e.fn.affix=r;return this};e(window).on("load",function(){e('[data-spy="affix"]').each(function(){var t=e(this);var r=t.data();r.offset=r.offset||{};if(r.offsetBottom)r.offset.bottom=r.offsetBottom;if(r.offsetTop)r.offset.top=r.offsetTop;n.call(t,r)})})}(jQuery)
