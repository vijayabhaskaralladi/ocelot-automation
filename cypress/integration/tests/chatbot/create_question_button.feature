Feature: Permissions - create new question button

  @low_priority
  Scenario: Create Question button
    Given Login using random user from the list
      | chatbotStandard         |
      | chatbotAdmin            |
      | viewOtherOfficesChatbot |
    And Open chatbot "chatbotForAutomation"
    When Click on "createContent.createContentMenuButton"
    Then Tag "h1" with text "Create Question" should "exist"

  @low_priority
  Scenario: Limited users shouldn't see Create Content button
    Given Login using random user from the list
      | chatbotLimited   |
      | liveChatLimited  |
      | campaignsLimited |
    When Open chatbot "chatbotForAutomation"
    Then Element "createContent.createContentMenuButton" should "not.exist"
