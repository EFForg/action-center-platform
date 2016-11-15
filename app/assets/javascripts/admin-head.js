//= require jquery
//= require lodash
//= require step

function ajax_get(url, cb){
  $.ajax({
    url: url,
    success: function(data){
      cb(null, data);
    },
    error: function(e){
      cb(e);
    }
  });
}
