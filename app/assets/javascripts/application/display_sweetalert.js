jQuery(function($){
  if($.cookie('sweetAlert')){
    sweetAlert(JSON.parse($.cookie('sweetAlert')));
    $.removeCookie('sweetAlert');
  }
})
