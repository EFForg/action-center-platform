@javascript
Feature: Image Gallery
  An activist
  Should be able to upload to and use files from the gallery

  @wip
  Scenario:  Activist manipulates the gallery and uses an image in an action
    Given my test env has Internet access and I have an S3 key
      And I exist as an activist
      And I am logged in

    When I click to add an image to the gallery of a new ActionPage
    Then the image shows up as uploaded over ajax

  Scenario: Activist searches for images in the gallery
    Given I exist as an activist
    And I am logged in

    And there is an uploaded file named "apple.png"
    And there is an uploaded file named "banana.png"
    And there is an uploaded file named "cherry.png"
    And there is an uploaded file named "mango.png"

    When I click to open the gallery of a new ActionPage
    Then I should see "mango.png" within ".gallery"
    And I should not see "apple.png" within ".gallery"

    When I fill in "f" with "apple"
    And I trigger a click on the element "input[value='Search']"

    Then I should see "apple.png" within ".gallery"
