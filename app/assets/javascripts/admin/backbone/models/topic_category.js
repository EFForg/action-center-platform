var TopicCategoryModel = Backbone.RelationalModel.extend({
  relations: [{
    type: Backbone.HasMany,
    key: 'topic_sets',
    relatedModel: 'TopicSetModel',
    collectionType: 'TopicSetCollection',
    reverseRelation: {
      keySource: 'topic_category_id',
      key: 'topic_category',
      includeInJSON: "id"
    }
  }],
});
