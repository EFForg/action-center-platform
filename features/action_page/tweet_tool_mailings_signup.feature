@javascript
Feature: Users can sign up for mailings on tweet action pages

  Background: Tweet actions should include an sign up form for mailings
    Given A tweet petition targeting senate exists
    When I browse to the action page
    Then I should see a sign up form for mailings

    When I enter the email "me@test.com" and click Sign Up
    And I wait for the tweet submission to succeed
    Then "me@test.com" should be signed up for mailings
