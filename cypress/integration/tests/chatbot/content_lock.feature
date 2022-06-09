Feature: Content Lock

  Scenario: TMD-81: Privileged users can edit locked custom questions
    Given Login using random user from the list
      | clientRelations |
      | sales           |
      | ocelotAdmin     |
      | chatbotAdmin    |
    And Open chatbot "chatbotForAutomation"
    And Open "Chatbot->Knowledgebase->Custom Questions" menu item
    And Intercept "${DRUPAL_URL}jsonapi/chatbot_question/chatbot_question*" as "searchRequest"
    And Type "Custom question for automation{enter}" in "chatbot.knowledgebase.customQuestions.search"
    And Wait for "searchRequest" network call
    When Click on "chatbot.knowledgebase.customQuestions.viewFirstQuestion"
    Then Tag "span" with text "Edit" should "exist"
    When Click on tag "span" which contains text "Edit"
    Then Tag "h1" with text "Edit Question" should "exist"
    And Verify that page contains text "Content Locked"

  Scenario: TMD-82: Non-privileged users can't edit locked custom questions
    Given Login using random user from the list
      | chatbotLimited  |
      | chatbotStandard |
    And Open chatbot "chatbotForAutomation"
    And Open "Chatbot->Knowledgebase->Custom Questions" menu item
    And Intercept "${DRUPAL_URL}jsonapi/chatbot_question/chatbot_question*" as "searchRequest"
    And Type "Custom question for automation{enter}" in "chatbot.knowledgebase.customQuestions.search"
    And Wait for "searchRequest" network call
    When Click on "chatbot.knowledgebase.customQuestions.viewFirstQuestion"
    Then Tag "span" with text "Edit" should "not.exist"
    When Click on tag "span" which contains text "View"
    Then Tag "h1" with text "View" should "exist"
    And Verify that page contains text "Content Locked"

  Scenario: TMD-83: Verify that locked custom questions contain info about locking
    Given Login as "defaultUser"
    And Open chatbot "chatbotForAutomation"
    And Open "Chatbot->Knowledgebase->Custom Questions" menu item
    And Intercept "${DRUPAL_URL}jsonapi/chatbot_question/chatbot_question*" as "searchRequest"
    And Type "Custom question for Content Lock tests{enter}" in "chatbot.knowledgebase.customQuestions.search"
    And Wait for "searchRequest" network call
    When Click on "chatbot.knowledgebase.customQuestions.viewFirstQuestion"
    And Click on tag "span" which contains text "View"
    Then Verify that page contains text "Content Locked"
    And Verify that page contains text "ocelot, admin"
    And Verify that page contains text "2022"
