Feature: Embedding

  Scenario: TMD-12: Verify that Chatbot->Embedding page contains correct JS script
    Given Login as "defaultUser"
    When Open chatbot "chatbotForAutomation"
    And Open "Chatbot->Embedding" menu item
    Then Verify that embedded script contains id for "chatbotForAutomation" chatbot

    When Open chatbot "aimsCommunityCollege"
    And Open "Chatbot->Embedding" menu item
    Then Verify that embedded script contains id for "aimsCommunityCollege" chatbot
