@javascript
Feature: Users can sign up for mailings on tweet action pages

  Background: Tweet actions should include an sign up form for mailings
    Given A tweet petition targeting senate exists
    When I browse to the action page
    Then I should see a sign up form for mailings

    When I enter my email address for mailings and click Sign Up
    Then I should have signed up for mailings
