var Router = Backbone.Router.extend({
  routes:{
    "topics":"topics"
  },

  topics: function(){
    $('.tab-pane').removeClass("active");
    $('#topics').addClass("active");      
    this.setCurrent("ul.nav-tabs li.topics");
  },

  setCurrent: function(button_id){
    $('ul.nav-tabs li').removeClass("active");
    $(button_id).addClass("active");
  }
 
});
