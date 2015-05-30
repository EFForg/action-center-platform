var TopicCollection = Backbone.Collection.extend({
  url : '/admin/topics',
  model: TopicModel,
  
  initialize: function(o){
    _.bindAll(this,'fetch');
    this.collection_name = 'topics';
    this.params = {
    };
  }
});
