import React, { useEffect, useRef, useState } from "react";

function jquery() {
  return window.jQuery || window.$;
}

function request(options) {
  return new Promise((resolve, reject) => {
    jquery().ajax({
      ...options,
      success: resolve,
      error: reject,
    });
  });
}

function sortTopicSets(topicSets) {
  return [...topicSets].sort((left, right) => left.tier - right.tier);
}

function Icon({ name }) {
  return <span className={`glyphicon glyphicon-${name}`} />;
}

function EditableText({
  editMode,
  inputRef,
  name,
  onChange,
  placeholder,
  value,
}) {
  if (editMode) {
    return (
      <input
        ref={inputRef}
        className="editable-text"
        name={name}
        onChange={onChange}
        placeholder={placeholder}
        value={value}
      />
    );
  }

  return <span className="editable-text">{value}</span>;
}

function TopicSetRow({ id, onDestroy, tier, topics: initialTopics }) {
  const [newTopicName, setNewTopicName] = useState("");
  const [topics, setTopics] = useState(initialTopics);
  const newTopicInputRef = useRef(null);

  const createTopic = async (event) => {
    event.preventDefault();

    try {
      const topic = await request({
        method: "post",
        url: event.target.action,
        processData: false,
        contentType: false,
        data: new FormData(event.target),
      });

      setTopics((currentTopics) => [...currentTopics, { id: topic.id, name: topic.name }]);
      setNewTopicName("");
      newTopicInputRef.current?.focus();
    } catch (_error) {
      window.alert("There has been an error creating this term.");
    }
  };

  const destroy = async () => {
    if (!window.confirm("Are you sure you want to delete this entire tier?")) {
      return;
    }

    try {
      await request({
        method: "post",
        url: `/admin/topic_sets/${id}`,
        data: { _method: "delete" },
      });

      onDestroy(id);
    } catch (_error) {
      window.alert("There has been an error deleting this tier.");
    }
  };

  const destroyTopic = async (topic) => {
    try {
      await request({
        method: "post",
        url: `/admin/topics/${topic.id}`,
        data: { _method: "delete" },
      });

      setTopics((currentTopics) => currentTopics.filter((currentTopic) => currentTopic.id !== topic.id));
    } catch (_error) {
      window.alert("There has been an error deleting this topic.");
    }
  };

  return (
    <tr data-set-id={id} className="topic_set">
      <td><span className="badge">{tier}</span></td>
      <td>
        <form action="/admin/topics" method="post" className="form-inline" onSubmit={createTopic}>
          <input type="hidden" name="topic[topic_set_id]" value={id} />
          <div className="input-group input-group-sm">
            <input
              ref={newTopicInputRef}
              className="form-control"
              name="topic[name]"
              onChange={(event) => setNewTopicName(event.target.value)}
              value={newTopicName}
            />
            <div className="input-group-btn">
              <button type="submit" title="Add term" className="btn btn-sm btn-success add_topic">
                <Icon name="doc-new" /> Add term
              </button>
            </div>
          </div>
        </form>

        <div className="topics">
          {topics.map((topic) => (
            <div className="btn-group btn-group-sm topic_set_edit" key={topic.id}>
              <span className="btn btn-sm btn-primary label label-primary">{topic.name}</span>
              <span className="btn btn-sm btn-danger delete-btn" onClick={() => destroyTopic(topic)}>
                <Icon name="ban-circle" />
                &nbsp;
              </span>
            </div>
          ))}
        </div>
      </td>
      <td>
        <div className="btn-group pull-right">
          <span onClick={destroy} className="btn btn-default btn-sm delete-btn">
            <Icon name="trash" /> Delete
          </span>
        </div>
      </td>
    </tr>
  );
}

function TopicCategory({
  editMode: initialEditMode = false,
  onDestroy,
  onSave,
  topicCategoryId,
  topicCategoryName: initialTopicCategoryName = "",
  topicSets: initialTopicSets = [],
}) {
  const [editMode, setEditMode] = useState(Boolean(initialEditMode));
  const [topicCategoryName, setTopicCategoryName] = useState(initialTopicCategoryName);
  const [topicSets, setTopicSets] = useState(initialTopicSets);
  const titleInputRef = useRef(null);
  const isNewRecord = !topicCategoryId;

  useEffect(() => {
    if (editMode) {
      titleInputRef.current?.select();
    }
  }, [editMode]);

  const save = async (event) => {
    event.preventDefault();

    if (!editMode) {
      setEditMode(true);
      return;
    }

    try {
      const topicCategory = await request({
        method: "post",
        url: `/admin/topic_categories/${isNewRecord ? "" : topicCategoryId}`,
        processData: false,
        contentType: false,
        data: new FormData(event.target),
      });

      if (isNewRecord) {
        setTopicCategoryName("");
      } else {
        setEditMode(false);
        setTopicCategoryName(topicCategory.name);
      }

      onSave(
        {
          topicCategoryId: topicCategory.id,
          topicCategoryName: topicCategory.name,
          topicSets: [],
        },
        isNewRecord,
      );
    } catch (_error) {
      window.alert("There has been an error creating this topic category.");
    }
  };

  const destroy = async () => {
    if (!window.confirm("Are you sure you want to delete this entire category?")) {
      return;
    }

    try {
      await request({
        method: "post",
        url: `/admin/topic_categories/${topicCategoryId}`,
        data: { _method: "delete" },
      });

      onDestroy(topicCategoryId);
    } catch (_error) {
      window.alert("There has been an error deleting this category.");
    }
  };

  const newTopicSet = async () => {
    try {
      const topicSet = await request({
        method: "post",
        url: "/admin/topic_sets",
        data: { "topic_set[topic_category_id]": topicCategoryId },
      });

      setTopicSets((currentTopicSets) => [{ id: topicSet.id, tier: topicSet.tier, topics: [] }, ...currentTopicSets]);
    } catch (_error) {
      window.alert("There has been an error creating this tier.");
    }
  };

  const saveAction = `/admin/topic_categories/${isNewRecord ? "" : topicCategoryId}`;
  const saveMethod = isNewRecord ? "post" : "patch";
  const saveUpdateClasses = `btn btn-success btn-sm ${isNewRecord ? "create_category" : "update_category"}`;
  const cancelDeleteClasses = `btn btn-sm delete-category-btn ${editMode ? "btn-warning" : "btn-danger"}`;
  const panelAttributes = isNewRecord ? {} : { "data-topic-category-id": topicCategoryId };

  return (
    <div>
      <div className="panel panel-default topic_category" {...panelAttributes}>
        <div className="panel-heading">
          <div className="panel-title">
            <form action={saveAction} method="post" onSubmit={save}>
              <input type="hidden" name="_method" value={saveMethod} />

              <EditableText
                editMode={editMode}
                inputRef={titleInputRef}
                name="topic_category[name]"
                onChange={(event) => setTopicCategoryName(event.target.value)}
                placeholder="Category name"
                value={topicCategoryName}
              />

              <div className="btn-group pull-right">
                <button type="submit" className={saveUpdateClasses}>
                  <Icon name={editMode ? "check" : "pencil"} />
                  {isNewRecord ? "Create" : editMode ? "Update" : "Edit"}
                </button>

                {!isNewRecord && (
                  <span
                    onClick={editMode ? () => setEditMode(false) : destroy}
                    className={cancelDeleteClasses}
                  >
                    <Icon name="trash" /> {editMode ? "Cancel" : "Delete"}
                  </span>
                )}
              </div>
            </form>
            <div className="clearfix" />
          </div>
        </div>

        {!isNewRecord && (
          <div className="panel-body">
            <table className="table table-simple" cellSpacing="0" cellPadding="0">
              <thead>
                <tr>
                  <th>Tier #</th>
                  <th>Terms</th>
                  <th>
                    <span onClick={newTopicSet} className="btn btn-default btn-sm create-btn pull-right">
                      <Icon name="doc-new" /> Create new tier
                    </span>
                  </th>
                </tr>
              </thead>
              <tbody>
                {sortTopicSets(topicSets).map((topicSet) => (
                  <TopicSetRow
                    id={topicSet.id}
                    key={topicSet.id}
                    onDestroy={(destroyedTopicSetId) => {
                      setTopicSets((currentTopicSets) => (
                        currentTopicSets.filter((currentTopicSet) => currentTopicSet.id !== destroyedTopicSetId)
                      ));
                    }}
                    tier={topicSet.tier}
                    topics={topicSet.topics}
                  />
                ))}
              </tbody>
            </table>
            <div className="clearfix" />
          </div>
        )}
      </div>
    </div>
  );
}

function TopicCategoryTables({ topicCategories: initialTopicCategories }) {
  const [topicCategories, setTopicCategories] = useState(initialTopicCategories);

  return (
    <div>
      <TopicCategory
        editMode
        onSave={(topicCategory, newRecord) => {
          if (!newRecord) {
            return;
          }

          setTopicCategories((currentTopicCategories) => [topicCategory, ...currentTopicCategories]);
        }}
      />

      {topicCategories.map((topicCategory) => (
        <TopicCategory
          key={topicCategory.topicCategoryId}
          onDestroy={(destroyedTopicCategoryId) => {
            setTopicCategories((currentTopicCategories) => (
              currentTopicCategories.filter(
                (currentTopicCategory) => currentTopicCategory.topicCategoryId !== destroyedTopicCategoryId,
              )
            ));
          }}
          {...topicCategory}
        />
      ))}
    </div>
  );
}

export default TopicCategoryTables;
