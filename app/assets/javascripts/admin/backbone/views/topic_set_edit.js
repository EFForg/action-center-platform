var TopicSetEditView = Backbone.View.extend({
  tagName: 'div',
  className: 'topic_set_edit',

  events: {
    "click .set_form_background": "cancel",
    "click .close": "cancel",
    "submit .term-form": "createTopic"
  },

  initialize: function(){
    _.bindAll(this, 'addOneTopic', 'createTopic', 'render');
    this.model.bind('refresh', this.render);
  },

  render: function(){
    $(this.el).html(JST['admin/backbone/templates/topic_set_edit'](this.getData()));
    this.addAllTopics();
  },

  getData: function(){
    return {
      category_name: this.model.get('topic_category').escape('name'),
      tier: this.model.get('tier'),
    }
  },

  addOneTopic: function(topic){
    var view = new TopicRowView({
      model: topic
    });
    view.render();
    $("table tbody", this.el).append(view.el);
    return view;
  },

  addAllTopics: function(){
    var that = this;
    this.model.get('topics').each(function(topic){
      that.addOneTopic(topic);
    });
  },

  cancel: function(){
    this.remove();
  },

  createTopic: function(){
    var that = this;
    var term = $("input.term", this.el).val();
    var topic = new TopicModel({
      name: term,
      topic_set: this.model
    });

    var view = this.addOneTopic(topic);
    $("input.term", this.el).val("").focus();

    topic.save({}, {
      success: function(model){
        view.render();
        act.collections.topics.add(model);
      },
      error: function(model){
        that.model.get('topics').remove(model);
        that.render();
        alert("There has been an error creating this term.");
      }
    });
    return false;
  }

});
