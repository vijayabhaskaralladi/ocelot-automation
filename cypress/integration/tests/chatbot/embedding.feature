Feature: Embedding

  Scenario: TMD-12: Verify that Chatbot->Embedding page contains correct JS script
    Given Login as "chatbotAdmin"
    And Open chatbot "chatbotForAutomation"
    When Open "Chatbot->Embedding" menu item
    Then Verify that embedded script contains id for "chatbotForAutomation" chatbot
