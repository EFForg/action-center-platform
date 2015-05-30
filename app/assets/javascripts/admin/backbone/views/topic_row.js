var TopicRowView = Backbone.View.extend({
  tagName: 'tr',

  events: {
    "click .delete-btn": "destroy",
  },
  
  render: function(){
    $(this.el).html(JST['admin/backbone/templates/topic_row'](this.getData()));
  },

  getData: function(){
    return {
      name: this.model.escape('name'),
      id: this.model.id
    }
  },

  destroy: function(){
    var that = this;
    this.model.destroy({
      error: function(){
        that.model.get('topic_set').trigger('refresh');
        alert('There has been an error deleting this topic.');
      },
      wait: true
    });
    this.remove();
  },

});
