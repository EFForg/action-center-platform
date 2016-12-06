@javascript
Feature: Edit topic categories
  An admin should be able to edit topic categories

  Background:
    Given I exist as an activist
    And I am logged in
    And there is a persisted TopicCategory with:
        |name|topical category|

  Scenario:
    When I am on "/admin/topics"
    And I click the first "[class=icon-pencil]"
    And I fill in the first ".topic_category[data-topic-category-id] [name=topic_category\[name\]]" with "edited topical category"
    And I click the first ".update_category"
    Then I should see "edited topical category" within ".topic_category[data-topic-category-id] .panel-title"
    And there should be a persisted TopicCategory with:
        |name|edited topical category|
    And there should not be a persisted TopicCategory with:
        |name|topical category|
