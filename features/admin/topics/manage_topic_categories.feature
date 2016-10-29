@javascript
Feature: Create topic categories
  An admin should be able to create topic categories

  Background:
    Given I exist as an activist
    And I am logged in

  Scenario:
    When I am on "/admin/action_pages#topics"
    And I click the element ".create-category-btn"
    And I fill in "topic_category[name]" with "newly made category"
    And I press "Add"
    Then I should see "newly made category" within ".panel.topic_category .panel-title"
    And there should be a persisted TopicCategory with:
        |name|newly made category|

  Scenario:
    When there is a persisted TopicCategory with:
        |name|topical category|
    And I am on "/admin/action_pages#topics"
    And I click the element ".edit-category-btn"
    And I fill in "topic_category[name]" with "edited topical category"
    And I press "Update"
    Then I should see "edited topical category" within ".panel.topic_category .panel-title"
    And there should be a persisted TopicCategory with:
        |name|edited topical category|
    And there should not be a persisted TopicCategory with:
        |name|topical category|

  Scenario:
    When there is a persisted TopicCategory
    And I am on "/admin/action_pages#topics"
    And I click the element ".create-btn"
    And I click the element ".topic_category .panel-body .edit-btn"
    And I fill in "topic[name]" with "newly made topic 1"
    And I press "Add"
    And I fill in "topic[name]" with "newly made topic 2"
    And I press "Add"

    Then I should see "newly made topic 1" within ".topic_category .panel-body .label-primary:nth-child(1)"
    And I should see "newly made topic 2" within ".topic_category .panel-body .label-primary:nth-child(2)"
    And there should be a persisted Topic with:
        |name|newly made topic 1|
    And there should be a persisted Topic with:
        |name|newly made topic 2|

  Scenario:
    When there is a persisted TopicCategory
    And it has a persisted item belonging to topic_sets
    And that has a persisted item belonging to topics
    And I am on "/admin/action_pages#topics"
    And I click the element ".topic_category .panel-body .edit-btn"
    And I click the element ".topic_set_edit .delete-btn"
    Then there should not be a persisted Topic

  Scenario:
    When there is a persisted TopicCategory
    And it has a persisted item belonging to topic_sets
    And that has a persisted item belonging to topics
    And I am on "/admin/action_pages#topics"
    And I click the element ".delete-btn"
    Then there should not be a persisted Topic
    And there should not be a persisted TopicSet

  Scenario:
    When there is a persisted TopicCategory
    And I am on "/admin/action_pages#topics"
    And I click the element ".delete-category-btn"
    Then there should not be a persisted TopicCategory


  Scenario:
    When there is a persisted TopicCategory
    And it has a persisted item belonging to topic_sets
      And that has a persisted item belonging to topics with:
         |name|topic 1|
    And it has a persisted item belonging to topic_sets
      And that has a persisted item belonging to topics with:
         |name|topic 2|
    And I am on "/admin/action_pages#topics"

    # this is a hack to drag the first row below the second
    And I drag ".topic_category tr[data-set-id]:nth-child(1)" onto ".topic_category .clearfix"

    And I pause a moment

    Then the topic set containing "topic 1" should be tier 2
    Then the topic set containing "topic 2" should be tier 1
