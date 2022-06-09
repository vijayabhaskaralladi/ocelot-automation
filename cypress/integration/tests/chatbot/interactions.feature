Feature: Chatbot interactions

  Scenario: TMD-30: Verify that Chatbot Interactions page contains latest messages
  Test creates 2 dialogs and checks that Chatbot interaction page contains messages from both dialogs

    Given Create random number and save it as "randomNumber1"
    And Create random number and save it as "randomNumber2"
    And API: Select "chatbotForAutomation" chatbot
    And API: Send first message "chatbotInteraction${randomNumber1}" and save response as "response1"
    And API: Send first message "chatbotInteraction${randomNumber2}" and save response as "response2"

    And Login using random user from the list
      | chatbotLimited          |
      | chatbotStandard         |
      | chatbotAdmin            |
      | viewOtherOfficesChatbot |
    And Open chatbot "chatbotForAutomation"

    When Open "Chatbot->Interactions" menu item
    Then Tag "em" with text "chatbotInteraction${randomNumber1}" should "exist"
    And Tag "em" with text "chatbotInteraction${randomNumber2}" should "exist"
