Feature: Permissions - moderation queue

  Scenario: Viewing Moderation Queue
    This test requires at least 1 record in Moderation Queue
    Given Login using random user from the list
      | chatbotStandard         |
      | chatbotAdmin            |
      | viewOtherOfficesChatbot |
    And Open chatbot "chatbotForAutomation"
    When Open "Chatbot->Knowledgebase->Moderation Queue" menu item
    And URL should include "moderation-queue"
    And Add "?startDate=2022-02-03" to the current URL
    Then Verify that selector "chatbot.knowledgebase.moderationQueue.cellsWithQuestion" contains more than "1" elements

  Scenario Outline: Verify that user <user_name> can't see Moderation Queue
    Given Login as "<user_name>"
    And Open chatbot "chatbotForAutomation"
    When Open "Chatbot->Knowledgebase" menu item
    Then Tag "span.MuiButton-label" with text "Moderation Queue" should "not.exist"
    Examples:
      | user_name               |
      | chatbotLimited          |
