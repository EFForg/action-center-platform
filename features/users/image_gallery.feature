@javascript
Feature: Image Gallery
  An activist
  Should be able to upload to and use files from the gallery

  Scenario:  Activist manipulates the gallery and uses an image in an action
    Given my test env has Internet access and I have an S3 key
      And I exist as an activist
      And I am logged in

    When I click to add an image to the gallery of a new ActionPage
    Then the image shows up as uploaded over ajax
