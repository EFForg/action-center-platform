
var TopicCategoryTables = React.createClass({
  getInitialState: function() {
    return { topicCategories: this.props.topicCategories }
  },

  newTopicCategory: function() {
    this.refs.newTopicCategory.edit();
  },

  onSaveTopicCategory: function(topicCategory, newRecord) {
    if (newRecord) {
      this.state.topicCategories.push(topicCategory);
      this.setState({ topicCategories: this.state.topicCategories });
    }
  },

  onDestroyTopicCategory: function(topicCategory) {
    var topicCategoryIndex = this.state.topicCategories.indexOf(topicCategory);
    this.state.topicCategories.splice(topicCategoryIndex, 1);
    this.setState({ topicCategories: this.state.topicCategories });
  },

  render: function() {
    var self = this;
    var topicCategory = function(topicCategory) {
      return <TopicCategory key={ topicCategory.topicCategoryId }
               onDestroy={ self.onDestroyTopicCategory.bind(self, topicCategory) }
               {...topicCategory} />;
    };

    return (
      <div>
        <div className="text-right">
          <span onClick={ this.newTopicCategory }
                className="btn btn-success create-category-btn">
            <Icon name="doc-new" /> Create new topic category
          </span>
        </div>

        { this.state.topicCategories.map(topicCategory) }

        <TopicCategory ref="newTopicCategory"
                       editMode={ true } onSave={ this.onSaveTopicCategory } />
      </div>
    );
  }
});

var TopicCategory = React.createClass({
  getInitialState: function() {
    return {
      topicCategoryName: this.props.topicCategoryName || "",
      topicSets: this.props.topicSets || [],
      editMode: !!this.props.editMode
    }
  },

  isNewRecord: function() {
    return !this.props.topicCategoryId;
  },

  edit: function() {
    var self = this;
    this.setState({ editMode: true }, function() {
      self.refs.title.select();
    });
  },

  cancelEdit: function() {
    this.setState({ editMode: false });
  },

  save: function(e) {
    e.preventDefault();

    if (!this.state.editMode)
      return this.edit();

    var self = this;
    var newRecord = this.isNewRecord();
    $.ajax({
      method: "post",
      url: e.target.action,

      processData: false,
      contentType: false,
      data: new FormData(e.target),

      success: function(topicCategory) {
        if (newRecord)
          self.refs.title.reset();
        else
          self.setState({ editMode: false, topicCategoryName: topicCategory.name });

        self.props.onSave && self.props.onSave({
          topicCategoryId: topicCategory.id,
          topicCategoryName: topicCategory.name
        }, newRecord);
      },

      error: function() {
        alert("There has been an error creating this topic category.");
      }
    });
  },

  destroy: function() {
    var self = this;
    if (confirm("Are you sure you want to delete this entire category?"))
      $.ajax({
        method: "post",
        url: "/admin/topic_categories/" + this.props.topicCategoryId,
        data: { _method: "delete" },

        success: function() {
          self.props.onDestroy && self.props.onDestroy();
        },

        error: function() {
          alert("There has been an error deleting this category.");
        }
      });
  },

  newTopicSet: function() {
    var self = this;

    $.ajax({
      method: "post",
      url: "/admin/topic_sets",
      data: { "topic_set[topic_category_id]": this.props.topicCategoryId },

      success: function(topicSet) {
        self.state.topicSets.push({
          id: topicSet.id,
          tier: topicSet.tier,
          topics: []
        });

        self.setState({ topicSets: self.state.topicSets });
      },

      error: function() {
        alert("There has been an error creating this tier.");
      }
    });
  },

  onDestroyTopicSet: function(topicSet) {
    this.state.topicSets.splice(this.state.topicSets.indexOf(topicSet), 1);
    this.setState({ topicSets: this.state.topicSets });
  },

  onMoveTopicSet: function(id) {

  },

  componentDidMount: function() {
    var self = this;
    if (this.refs.table) {
      $(this.refs.table).sortable({
        containerSelector: "table",
        itemPath: "> tbody",
        itemSelector: "tr[data-set-id]",
        placeholder: '<tr class="placeholder"></tr>',
        onDrop: function($item, container) {
          $item.removeClass("dragged").removeAttr("style")
          $("body").removeClass("dragging")

          var updates = $.map($("tr[data-set-id]", self.refs.table), function(tr, i) {
            var id = $(tr).data("set-id");

            var topicSet = null;
            self.state.topicSets.forEach(function(set) {
              if (set.id == id)
                topicSet = set;
            });

            return $.ajax({
                method: "post",
                url: "/admin/topic_sets/" + topicSet.id,
                data: { _method: "patch", "topic_set[tier]": i + 1 },

                success: function() {
                  topicSet.tier = i + 1;
                },

                error: function() {
                  alert("There has been an error updating this tier.");
                }
            });
          });

          $.when.apply($, updates).done(function() {
            self.setState({ topicSets: self.state.topicSets });
          });
        }
      });
    }
  },

  render: function() {
    var self = this;
    var topicSetRow = function(topicSet) {
      return <TopicSetRow {...topicSet} key={ topicSet.id }
                          onDestroy={ self.onDestroyTopicSet.bind(self, topicSet) }/>;
    };

    var editMode = this.state.editMode;
    var isNewRecord = this.isNewRecord();
    var panelAttrs = isNewRecord ? {} : { "data-topic-category-id": this.props.topicCategoryId };
    var saveAction = "/admin/topic_categories/" + (isNewRecord ? '' : this.props.topicCategoryId);
    var saveMethod = isNewRecord ? "post" : "patch";

    var topicSets = this.state.topicSets.slice(0).sort(function(set1, set2) {
      return set1.tier - set2.tier;
    });

    return (
      <div>
        <div className="panel panel-default topic_category" {...panelAttrs}>
          <div className="panel-heading">
            <div className="panel-title">
              <form action={ saveAction } method="post" onSubmit={ this.save }>
                <input type="hidden" name="_method" value={ saveMethod } />
                <EditableText ref="title" editMode={ editMode }
                              name="topic_category[name]" value={ this.state.topicCategoryName }
                              placeholder="Category name" />

                <div className="btn-group category pull-right edit-category-btn" key="saveOrEdit">
                  <button type="submit" className="btn btn-success btn-sm update_category">
                    <Icon name={ editMode ? "check" : "pencil" } />
                    { isNewRecord ? "Create" : editMode ? "Update" : "Edit" }
                  </button>

                  <Conditional when={ !isNewRecord }>
                    <span onClick={ editMode ? this.cancelEdit : this.destroy }
                          className="btn btn-success btn-sm delete-category-btn" key="destroyOrCancel">
                      <Icon name="trash" /> { editMode ? "Cancel" : "Delete" }
                    </span>
                  </Conditional>
                </div>
              </form>
            </div>
          </div>

          <Conditional when={ !isNewRecord }>
            <div className="panel-body">
              <table ref="table" className="table table-simple" cellSpacing="0" cellPadding="0">
                <thead>
                  <tr>
                    <th>Tier #</th>
                    <th>Terms</th>
                    <th>
                      <span onClick={ this.newTopicSet }
                            className="btn btn-default btn-sm create-btn pull-right">
                        <Icon name="doc-new" /> Create new tier
                      </span>
                    </th>
                  </tr>
                </thead>
                <tbody>
                  { topicSets.map(topicSetRow) }
                </tbody>
              </table>
              <div className="clearfix">
              </div>
            </div>
          </Conditional>
        </div>
      </div>
    );
  }
});

var TopicSetRow = React.createClass({
  getInitialState: function() {
    return {
      topics: this.props.topics,
      newTopicName: ''
    };
  },

  destroy: function() {
    var self = this;
    if (confirm("Are you sure you want to delete this entire tier?"))
      $.ajax({
        method: "post",
        url: "/admin/topic_sets/" + this.props.id,
        data: { _method: "delete" },

        success: function() {
          self.props.onDestroy && self.props.onDestroy();
        },

        error: function() {
          alert("There has been an error deleting this tier.");
        }
      });
  },

  updateNewTopicName: function(e) {
    this.setState({ newTopicName: e.target.value });
  },

  createTopic: function(e) {
    e.preventDefault();

    var self = this;
    $.ajax({
      method: "post",
      url: e.target.action,

      processData: false,
      contentType: false,
      data: new FormData(e.target),

      success: function(topic) {
        self.state.topics.push({ id: topic.id, name: topic.name });
        self.setState({ topics: self.state.topics, newTopicName: '' }, function() {
          self.refs.newTopicInput.focus();
        });
      },

      error: function() {
        alert("There has been an error creating this term.");
      }
    });
  },

  destroyTopic: function(topic) {
    var self = this;
    $.ajax({
      method: "post",
      url: "/admin/topics/" + topic.id,
      data: { _method: "delete" },

      success: function() {
        self.state.topics.splice(self.state.topics.indexOf(topic), 1);
        self.setState({ topics: self.state.topics });
      },

      error: function() {
        alert("There has been an error deleting this topic.");
      }
    });
  },

  render: function() {
    var self = this;
    var editMode = this.state.editMode;
    var topicLabel = function(topic) {
      return (
        <div className="btn-group btn-group-sm topic_set_edit" key={ topic.id }>
          <span className="btn label label-primary">{ topic.name }</span>
          <span className="btn btn-danger delete-btn"
                onClick={ self.destroyTopic.bind(self, topic) }>
            <Icon name="cancel-circled-outline" />
          </span>
        </div>
      );
    };

    return (
      <tr data-set-id={ this.props.id } className="topic_set">
        <td><span className="badge">{ this.props.tier }</span></td>
        <td>
          <form action="/admin/topics" method="post"
                onSubmit={ this.createTopic } >
            <div className="input-group input-group-sm">
              <input type="hidden" name="topic[topic_set_id]" value={ this.props.id } />
              <input ref="newTopicInput"
                     className="form-control"
                     name="topic[name]"
                     value={ this.state.newTopicName }
                     onChange={ this.updateNewTopicName } />
              <span className="input-group-btn">
                <button type="submit"
                        title="Add topic"
                        className="btn btn-success add_topic">
                  <Icon name="doc-new" /> <span className="sr-only">Add topic</span>
                </button>
              </span>
            </div>
          </form>

          <div className="topics">
            { this.state.topics.map(topicLabel) }
          </div>
        </td>
        <td>
          <div className="btn-group pull-right">
            <span onClick={ this.destroy }
                  className="btn btn-default btn-sm delete-btn">
              <Icon name="trash" /> Delete
            </span>
          </div>
        </td>
      </tr>
    )
}
});
