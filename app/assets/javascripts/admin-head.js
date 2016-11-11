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

$(function(){
  var csrfToken = $("meta[name='csrf-token']").attr('content');
  Backbone.sync = (function(original) {
    return function(method, model, options) {
      options.beforeSend = function(xhr) {
        xhr.setRequestHeader('X-CSRF-Token', csrfToken);
      };
      original(method, model, options);
    };
  })(Backbone.sync);
});

var act = {};
act.edit_parent_selector = ".wrapper";
act.collections = {};
act.collections.topics = new TopicCollection();
act.collections.topic_sets = new TopicSetCollection();
act.collections.topic_categories = new TopicCategoryCollection();
act.views = {};

/*var router = new Router()*/

Step(
  function fetchCollectionsInParallel(){
    var async_fetch = function(fetch_function, cb){
      fetch_function({
        success: function(){
          cb(null);
        },
        error: function(e){
          cb(e);
        }
      });
    };

    async_fetch(act.collections.topics.fetch, this.parallel());
    async_fetch(act.collections.topic_sets.fetch, this.parallel());
    async_fetch(act.collections.topic_categories.fetch, this.parallel());

    var dom_parallel = this.parallel();
    $(function(){
      dom_parallel(null);
    });
  },
  function createViews(){
    Backbone.history.start();

    act.views.topic_categories = new TopicCategoriesView({
      el: document.getElementById("topics"),
      collection: act.collections.topic_categories
    });

    act.views.topic_categories.render();

    /*$(".nav-tabs li a").click(function(e){*/
      /*var hash = $(e.target).attr("href").replace("#","");*/
      /*router.navigate(hash);*/
    /*});*/
  }
);
