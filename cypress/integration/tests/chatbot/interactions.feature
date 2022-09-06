Feature: Chatbot interactions

  Scenario: TMD-30: Chatbot Interactions
  Test creates 2 dialogs and checks that Chatbot interaction page contains messages from both dialogs and then
  downloads interactions and checks the content
    Given Create random number and save it as "randomNumber1"
    And Create random number and save it as "randomNumber2"
    And API: Select "chatbotForAutomation" chatbot
    And API: Send first message "chatbotInteraction${randomNumber1}" and save response as "response1"
    And API: Send first message "chatbotInteraction${randomNumber2}" and save response as "response2"

    And Login using random user from the list
      | chatbotStandard         |
      | chatbotAdmin            |
      | viewOtherOfficesChatbot |
    And Open chatbot "chatbotForAutomation"

    When Open "Chatbot->Interactions" menu item
    Then Tag "em" with text "chatbotInteraction${randomNumber1}" should "exist"
    And Tag "em" with text "chatbotInteraction${randomNumber2}" should "exist"

    When Add reload event listener
    And Click on "chatbot.interactions.exportInteractions"
    Then Verify that download folder contains "interactions-"
    And Get full file name with prefix "interactions-" in download folder and save it as "interactionsFileName"
    And Verify that file "${interactionsFileName}" from download folder contains text "chatbotInteraction${randomNumber1}"
    And Verify that file "${interactionsFileName}" from download folder contains text "chatbotInteraction${randomNumber2}"

   Scenario: Viewing interactions
     Given Create random number and save it as "randomNumber"
     And API: Select "chatbotForAutomation" chatbot
     And API: Send first message "chatbotInteraction${randomNumber}" and save response as "response1"
     Given Login as "defaultUser"
     And Open chatbot "chatbotForAutomation"
     When Open "Chatbot->Interactions" menu item
     And Retrieve text from "chatbot.interactions.chatbotInteractions" and save as "conversationText"
     And Click on "chatbot.interactions.viewConversationButton"
     And Tag "span" with text "${conversationText}" should "exist"
     And Tag "ul div" with text "chatbotInteraction${randomNumber}" should "exist"
