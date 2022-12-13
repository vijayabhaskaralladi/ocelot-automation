Feature: Permissions - moderation queue

  Scenario: Viewing and Exporting Moderation Queue
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
    And Retrieve text from "chatbot.knowledgebase.moderationQueue.firstRowQuestion" and save as "moderationQueueQuestion"

    When Add reload event listener
    And Click on "common.questions.exportResultsToCSV"
    Then Verify that download folder contains "api-chatbot-kb-moderation-queue-"
    And Get full file name with prefix "api-chatbot-kb-moderation-queue-" in download folder and save it as "moderationQueueFileName"
    And Verify that file "${moderationQueueFileName}" from download folder contains text "${moderationQueueQuestion}"

  Scenario: Limited user can't see Moderation Queue
    Given Login as "chatbotLimited"
    And Open chatbot "chatbotForAutomation"
    When Open "Chatbot->Knowledgebase" menu item
    Then Tag "li>a" with text "Moderation Queue" should "not.exist"
