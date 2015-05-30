var TopicCategoryEditView = Backbone.View.extend({
  tagName: 'div',
  className: 'topic_category_edit',

  events: {
    "click .set_form_background": "cancel",
    "click .close": "cancel",
    "submit .name-form": "createOrEdit"
  },

  initialize: function(){
    _.bindAll(this, 'render');
  },

  render: function(){
    $(this.el).html(JST['admin/backbone/templates/topic_category_edit'](this.getData()));

    // hacky, but for some reason focus() doesn't work in chrome without the timeout
    setTimeout(function(){
      $(".name", this.el).focus();
    }, 0);
  },

  getData: function(){
    return {
      id: this.model ? this.model.id : "",
      name: this.model ? this.model.get('name') : "",
    }
  },

  cancel: function(){
    this.remove();
  },

  createOrEdit: function(){
    var name = $("input.name", this.el).val();

    if(this.model){
      this.edit(name);
    } else {
      this.create(name);
    }

    this.remove();
    return false;
  },

  edit: function(name){
    this.model.save({name: name}, {
      error: function(){
        alert("There has been an error editing this topic category.");
      },
      wait: true
    });
  },

  create: function(name){
    var topic_category = new TopicCategoryModel({
      name: name
    });

    act.collections.topic_categories.add(topic_category);

    topic_category.save({}, {
      error: function(model){
        act.collections.topic_categories.remove(model);
        alert("There has been an error creating this topic category.");
      }
    });
  }

});
