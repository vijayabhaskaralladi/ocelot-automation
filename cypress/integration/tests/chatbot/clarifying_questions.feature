Feature: Clarifying Questions Library

  Scenario: View/Search Clarifying Questions
    Given Login as "defaultUser"
    And Open chatbot "chatbotForAutomation"
    And Open "Chatbot->Knowledgebase->Clarifying Questions Library" menu item
    And Verify that page contains titles "Clarifying Questions Library"
    And Create random number and save it as "id"
    When Create Clarifying Question
      | title    | Automated title ${id}                  |
      | question | Automated Question ${id}               |
      | choices  | choice 1-${id};choice 2-${id};choice 3 |
    And Type "Automated title ${id}" in "chatbot.clarifyingQuestions.searchQuestion"
    And Verify that page contains text "1–1 of 1"
    And Click on tag "button" which contains text "Preview"
    Then Verify that page contains text "Automated Question ${id}"
    Then Verify that page contains text "choice 1-${id}"

  Scenario: Editing/Deleting Clarifying Questions
    Given Login as "defaultUser"
    And Open chatbot "chatbotForAutomation"
    And Open "Chatbot->Knowledgebase->Clarifying Questions Library" menu item
    And Verify that page contains titles "Clarifying Questions Library"
    And Create random number and save it as "ids"
    When Create Clarifying Question
      | title    | Automated title ${ids}          |
      | question | Automated Question ${ids}       |
      | choices  | choice 1-${ids};choice 2-${ids} |
    And Type "Automated title ${ids}" in "chatbot.clarifyingQuestions.searchQuestion"
    And Verify that page contains text "1–1 of 1"
    And Click on "chatbot.clarifyingQuestions.editButton"
    And Click on tag "li" which contains text "Edit"
    And Type "Edited ${ids}" in "chatbot.clarifyingQuestions.editTitle"
    And Click on "chatbot.clarifyingQuestions.saveBtn"
    And Check that notification message "Saved" appeared
    Then Type "Edited ${ids}" in "chatbot.clarifyingQuestions.searchQuestion"
    And Verify that page contains text "1–1 of 1"
    And Click on "chatbot.clarifyingQuestions.editButton"
    And Click on tag "li" which contains text "Delete"
    And Click on tag "button" which contains text "Delete"
    And Check that notification message "Deleted" appeared

