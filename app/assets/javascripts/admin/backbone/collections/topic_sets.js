var TopicSetCollection = Backbone.Collection.extend({
  url: '/admin/topic_sets',
  model: TopicSetModel,
  
  initialize: function(o){
    _.bindAll(this,'fetch');
    this.collection_name = 'topic_sets';
    this.params = {
    };
  }

});
