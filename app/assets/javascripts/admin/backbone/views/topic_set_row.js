var TopicSetRowView = Backbone.View.extend({
  tagName: 'tr',

  events: {
    "click .delete-btn": "destroy",
    "click .edit-btn": "edit"
  },

  initialize: function(){
    _.bindAll(this, 'render');
    this.model.bind("remove:topics", this.render);
    this.model.bind("add:topics", this.render);
    this.model.bind("refresh", this.render);
    this.model.bind("change", this.render);
  },
  
  render: function(){
    $(this.el).html(JST['admin/backbone/templates/topic_set_row'](this.getData()));
    if(this.model.id){
      $(this.el).attr('data-set-id', this.model.id);
    }
  },

  getData: function(){
    return {
      tier: this.model.get('tier'),
      topics: this.getTopicsList(),
      id: this.model.id
    }
  },

  getTopicsList: function(){
    return this.model.get('topics').map(function(topic){
      return topic.escape('name');
    });
  },

  destroy: function(el){
    var that = this;
    var destroy_confirm = confirm($(el.target).data("confirm"));
    if(destroy_confirm){
      this.model.destroy({
        error: function(){
          that.model.get('topic_category').trigger('refresh');
          alert('There has been an error deleting this tier.');
        },
        wait: true
      });
      this.remove();
    }
  },

  edit: function(){
    var view = new TopicSetEditView({
      model: this.model
    });
    view.render();
    $(act.edit_parent_selector).prepend(view.el);
  }

});
