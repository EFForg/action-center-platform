@javascript
Feature: Create topic categories
  An admin should be able to create topic categories

  Background:
    Given I exist as an activist
    And I am logged in

  Scenario:
    When I am on "/admin/topics"
    And I fill in "topic_category[name]" with "newly made category"
    And I click the first ".create_category"
    Then I should see "newly made category" within ".topic_category[data-topic-category-id] .panel-title"
    And there should be a persisted TopicCategory with:
        |name|newly made category|
