var TopicCategoryTableView = Backbone.View.extend({
  events: {
    "click .create-btn": "createSet",
    "click .delete-category-btn": "destroy",
    "click .edit-category-btn": "edit"
  },

  initialize: function(o){
    _.bindAll(this, 'getData', 'render', 'addOneSet', 'createSet', 'destroy', 'edit');
    this.model.bind("add:topic_sets", this.addOneSet);
    this.model.bind("refresh", this.render);
    this.model.bind("change", this.render);
  },

  tr_movable_selector: 'tr[data-set-id]:not([data-set-id=""])',

  render: function(){
    var that = this;

    $(this.el).html(JST['admin/backbone/templates/topic_category'](this.getData()));
    this.addAllSets();

    $("table", this.el).sortable({
      containerSelector: 'table',
      itemPath: '> tbody',
      itemSelector: this.tr_movable_selector,
      placeholder: '<tr class="placeholder"/>',
      onDrop: function($item, container){
        $item.removeClass("dragged").removeAttr("style")
        $("body").removeClass("dragging")
        $(that.tr_movable_selector, container.el).each(function(i, tr){
          var set_id = $(tr).data('set-id');
          var set = act.collections.topic_sets.get(set_id);
          set.set('tier', i+1);
          set.save();
        });
      }
    });
  },

  addAllSets: function(){
    var that = this;
    this.model.get('topic_sets').each(function(set){
      that.addOneSet(set);
    });
  },

  addOneSet: function(set){
    var view = new TopicSetRowView({
      model: set
    });
    view.render();
    $("table tbody", this.el).append(view.el);
    return view;
  },

  getData: function(){
    return {
      name: this.model.escape('name'),
      id: this.model.id
    }
  },

  createSet: function(){
    var that = this;

    set = new TopicSetModel({
      topic_category: this.model,
      tier: _.max(_.union(this.model.get('topic_sets').map(function(topic_set){
        return topic_set.get('tier');
      }), [0])) + 1
    });

    set.save({}, {
      success: function(model){
        act.collections.topic_sets.add(model);
        model.trigger('refresh');
      },
      error: function(model){
        that.model.get('topic_sets').remove(model);
        that.render();
        alert("There has been an error creating this tier.");
      }
    });
  },

  destroy: function(el){
    var that = this;
    var destroy_confirm = confirm($(el.target).data("confirm"));
    if(destroy_confirm){
      this.model.destroy({
        error: function(){
          act.views.topic_categories.render();
          alert('There has been an error deleting this category.');
        },
        wait: true
      });
      this.remove();
    }
  },

  edit: function(){
    var view = new TopicCategoryEditView({
      model: this.model
    });
    view.render();
    $(act.edit_parent_selector).prepend(view.el);
  }

});
