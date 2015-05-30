var TopicCategoryCollection = Backbone.Collection.extend({
  url: '/admin/topic_categories',
  model: TopicCategoryModel,
  
  initialize: function(o){
    _.bindAll(this,'fetch');
    this.collection_name = 'topic_categories';
    this.params = {
    };
  }

});
