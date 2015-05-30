var TopicCategoriesView = Backbone.View.extend({
  events: {
    "click .create-category-btn": "createNewCategoryView"
  },

  initialize: function(o){
    _.bindAll(this,'render','addOne','addAll');
    this.collection.bind('add',   this.addOne);
    this.collection.bind('reset',   this.render);
  },

  render: function(){
    $(this.el).empty();
    $(this.el).html(JST['admin/backbone/templates/topic_categories']());
    this.addAll();
  },

  addOne: function(item){
    $('.no-rows', this.el).hide(); 
    var view = new TopicCategoryTableView({
      model: item
    });
    view.render();
    $(this.el).append(view.el);
  },

  addAll: function(){
    this.collection.each(this.addOne);
  },

  createNewCategoryView: function(){
    var view = new TopicCategoryEditView();
    view.render();
    $(act.edit_parent_selector).prepend(view.el);
  }
});
