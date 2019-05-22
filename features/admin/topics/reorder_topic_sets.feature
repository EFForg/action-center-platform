# This feature was briefly disabled by the rails 5 upgrade
# @javascript
# Feature: Reorder topic sets
#   An admin should be able to reorder topic sets
# 
#   Background:
#     Given I exist as an activist
#     And I am logged in
#     And there is a persisted TopicCategory
#     And it has a persisted item belonging to topic_sets
#       And that has a persisted item belonging to topics with:
#          |name|topic 1|
#     And it has a persisted item belonging to topic_sets
#       And that has a persisted item belonging to topics with:
#          |name|topic 2|
# 
#   Scenario:
#     When I am on "/admin/topics"
# 
#     # this drags the first row below the second
#     And I drag ".topic_category tr[data-set-id]:nth-child(1)" onto ".topic_category .clearfix"
# 
#     And I pause a moment
# 
#     Then the topic set containing "topic 1" should be tier 2
#     Then the topic set containing "topic 2" should be tier 1
