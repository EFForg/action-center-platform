@javascript
Feature: Image Gallery
  An activist
  Should be able to upload to and use files from the gallery

  Scenario:  Activist manipulates the gallery and uses an image in an action
    Given I exist as an activist
      And I am logged in
      When I visit the admin page
      And I click to create an action
      Then I see inputs for a new action_page
      When I click to add an image to the gallery
      Then the image shows up as uploaded over ajax
