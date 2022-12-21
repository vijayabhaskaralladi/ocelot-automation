Feature: Clarifying Questions Library

  @ignore
#  Ignored beccause feature is not released yet
  Scenario: Viewing Clarifying Questions
    Given Login as "defaultUser"
    And Open chatbot "chatbotForAutomation"
    And Open "Chatbot->Knowledgebase->Clarifying Questions Library" menu item
    And Verify that page contains titles "Clarifying Questions Library"