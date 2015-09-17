

/* jRumble v1.3 - http://jackrugile.com/jrumble - MIT License */
(function(f){f.fn.jrumble=function(g){var a=f.extend({x:2,y:2,rotation:1,speed:15,opacity:false,opacityMin:0.5},g);return this.each(function(){var b=f(this),h=a.x*2,i=a.y*2,k=a.rotation*2,g=a.speed===0?1:a.speed,m=a.opacity,n=a.opacityMin,l,j,o=function(){var e=Math.floor(Math.random()*(h+1))-h/2,a=Math.floor(Math.random()*(i+1))-i/2,c=Math.floor(Math.random()*(k+1))-k/2,d=m?Math.random()+n:1,e=e===0&&h!==0?Math.random()<0.5?1:-1:e,a=a===0&&i!==0?Math.random()<0.5?1:-1:a;b.css("display")==="inline"&&(l=true,b.css("display","inline-block"));b.css({position:"relative",left:e+"px",top:a+"px","-ms-filter":"progid:DXImageTransform.Microsoft.Alpha(Opacity="+d*100+")",filter:"alpha(opacity="+d*100+")","-moz-opacity":d,"-khtml-opacity":d,opacity:d,"-webkit-transform":"rotate("+c+"deg)","-moz-transform":"rotate("+c+"deg)","-ms-transform":"rotate("+c+"deg)","-o-transform":"rotate("+c+"deg)",transform:"rotate("+c+"deg)"})},p={left:0,top:0,"-ms-filter":"progid:DXImageTransform.Microsoft.Alpha(Opacity=100)",filter:"alpha(opacity=100)","-moz-opacity":1,"-khtml-opacity":1,opacity:1,"-webkit-transform":"rotate(0deg)","-moz-transform":"rotate(0deg)","-ms-transform":"rotate(0deg)","-o-transform":"rotate(0deg)",transform:"rotate(0deg)"};b.bind({startRumble:function(a){a.stopPropagation();clearInterval(j);j=setInterval(o,g)},stopRumble:function(a){a.stopPropagation();clearInterval(j);l&&b.css("display","inline");b.css(p)}})})}})(jQuery);

function isValidPhoneNumber(value) {
  if (!value) return false;
  var count = value.length;
  return count == 10 || count == 11;
}
function rumbleEl(el) {
  var prevBorder = el.css('border');
  el.css('border', '1px solid #ff0000');
  el.jrumble({})
  el.trigger('startRumble');
  var demoTimeout = setTimeout(function(){el.trigger('stopRumble');
      el.css('border', prevBorder);
  }, 500)
}


$(document).on('ready', function() {
  jQuery(".timeago").timeago();

});
// Enables popover on the action pages.
$('.customize-message-popover').popover();
$('.privacy-notice-popover').popover();

// Checkbox replacement

/*!
 * ScrewDefaultButtons v2.0.6
 * http://screwdefaultbuttons.com/
 *
 * Licensed under the MIT license.
 * Copyright 2013 Matt Solano http://mattsolano.com
 * EFF/Sina custom fork: https://github.com/sinak/ScrewDefaultButtonsV2
 *
 * Date: Mon February 25 2013
 */(function(e,t,n,r){var i={init:function(t){var n=e.extend({image:null,width:50,height:50,disabled:false},t);return this.each(function(t){var r=e(this);var i=n.image;var s=r.data("sdb-image");if(s){i=s}if(!i){e.error("There is no image assigned for ScrewDefaultButtons")}r.wrap("<div >").css({display:"none"});var o=r.attr("class");var u=r.attr("onclick");var a=r.parent("div");var f=r.attr("id");var l=f&&e('label[for="'+f+'"]');if(l){a.attr("title",l.text())}a.addClass(o);a.attr("onclick",u);a.css({"background-image":i,width:n.width,height:n.height,cursor:"pointer"});var c=0;var h=-n.height;if(r.is(":disabled")){c=-(n.height*2);h=-(n.height*3)}r.on("disableBtn",function(){r.attr("disabled","disabled");c=-(n.height*2);h=-(n.height*3);r.trigger("resetBackground")});r.on("enableBtn",function(){r.removeAttr("disabled");c=0;h=-n.height;r.trigger("resetBackground")});r.on("resetBackground",function(){if(r.is(":checked")){a.css({backgroundPosition:"0 "+h+"px"})}else{a.css({backgroundPosition:"0 "+c+"px"})}});r.trigger("resetBackground");if(r.is(":checkbox")){a.on("click",function(){if(!r.is(":disabled")){r.change()}});a.on("keydown",function(e){if(e.which===32){e.preventDefault();a.trigger("click")}});a.addClass("styledCheckbox");a.attr("tabindex","0");a.attr("role","checkbox");r.on("change",function(){if(r.prop("checked")){r.prop("checked",false);a.css({backgroundPosition:"0 "+c+"px"});a.attr("aria-checked","false")}else{r.prop("checked",true);a.css({backgroundPosition:"0 "+h+"px"});a.attr("aria-checked","true")}})}else if(r.is(":radio")){a.addClass("styledRadio");var p=r.attr("name");var d=e('input[name="'+p+'"]:checked');a.attr("tabindex","-1");if(d.length>0){e(d[0].parentNode).attr("tabindex","0")}else if(t===0){a.attr("tabindex","0")}a.attr("role","radio");a.on("click",function(){if(!r.prop("checked")&&!r.is(":disabled")){r.change()}e('input[name="'+p+'"]').each(function(){e(this).parent().attr("tabindex","-1").attr("aria-checked","false")});a.attr("tabindex","0").attr("aria-checked","true");a[0].focus()});var v=e('input[name="'+p+'"]');a.on("keydown",function(t){var n;var i=e.inArray(r[0],v);var s=t.which;if(s==13||s===32){t.preventDefault();a.trigger("click")}else if(s===37||s===38){if(i>-1&&v[i-1]){n=v[i-1].parentNode;t.preventDefault();e(n).trigger("click")}}else if(s===39||s===40){if(i>-1&&v[i+1]){n=v[i+1].parentNode;t.preventDefault();e(n).trigger("click")}}});r.on("change",function(){if(r.prop("checked")){r.prop("checked",false);a.css({backgroundPosition:"0 "+c+"px"})}else{r.prop("checked",true);a.css({backgroundPosition:"0 "+h+"px"});var t=e('input[name="'+p+'"]').not(r);t.trigger("radioSwitch")}});r.on("radioSwitch",function(){a.css({backgroundPosition:"0 "+c+"px"})});var m=e(this).attr("id");var g=e('label[for="'+m+'"]');g.on("click",function(){a.trigger("click")})}if(!e.support.leadingWhitespace){var m=e(this).attr("id");var g=e('label[for="'+m+'"]');g.on("click",function(){a.trigger("click")})}})},check:function(){return this.each(function(){var t=e(this);if(!i.isChecked(t)){t.change()}})},uncheck:function(){return this.each(function(){var t=e(this);if(i.isChecked(t)){t.change()}})},toggle:function(){return this.each(function(){var t=e(this);t.change()})},disable:function(){return this.each(function(){var t=e(this);t.trigger("disableBtn")})},enable:function(){return this.each(function(){var t=e(this);t.trigger("enableBtn")})},isChecked:function(e){if(e.prop("checked")){return true}return false}};e.fn.screwDefaultButtons=function(t,n){if(i[t]){return i[t].apply(this,Array.prototype.slice.call(arguments,1))}else if(typeof t==="object"||!t){return i.init.apply(this,arguments)}else{e.error("Method "+t+" does not exist on jQuery.screwDefaultButtons")}};return this})(jQuery)

    $('input:radio').screwDefaultButtons({
        image: 'url("/checkbox.png")',
        width: 15,
        height: 15
    });

function addCharacterCount(input) {
  var $input    = $(input),
      maxLength = $input.data('maxlength'),
      remaining = maxLength - $input.val().length;
  $('<div class="character-counter-text"><span id="' + input.id + '-counter">' + remaining + '</span> characters remaining (max ' + maxLength + ')</div>').insertAfter(input);
}

$('.charactercount').each(function () {
  addCharacterCount(this);
});

$('.charactercount').keyup(function() {
  var $element = $(this),
      maxLength = $element.data('maxlength');
      $("#" + this.id + "-counter").html(maxLength - $element.val().length);
});
