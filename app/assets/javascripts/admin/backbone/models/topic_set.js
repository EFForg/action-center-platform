var TopicSetModel = Backbone.RelationalModel.extend({
  relations: [{
    type: Backbone.HasMany,
    key: 'topics',
    relatedModel: 'TopicModel',
    collectionType: 'TopicCollection',
    reverseRelation: {
      keySource: 'topic_set_id',
      key: 'topic_set',
      includeInJSON: "id"
    }
  }],
});
