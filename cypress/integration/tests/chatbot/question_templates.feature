Feature: Permissions - question templates

  Scenario: Viewing Question Templates
    Given Login using random user from the list
      | chatbotLimited          |
      | chatbotStandard         |
      | chatbotAdmin            |
      | viewOtherOfficesChatbot |
    And Open chatbot "chatbotForAutomation"
    When Open "Chatbot->Knowledgebase->Question Templates" menu item
    And Click on "common.questions.viewFirstQuestion"
    Then Element "div>div.Mui-expanded" should "exist"

  Scenario: Searching Question Templates
    Given Login using random user from the list
      | chatbotLimited          |
      | chatbotStandard         |
      | chatbotAdmin            |
      | viewOtherOfficesChatbot |
    And Open chatbot "chatbotForAutomation"
    When Open "Chatbot->Knowledgebase->Question Templates" menu item
    And Find "${searchQuestionTemplate}"
    And Verify that selector "chatbot.knowledgebase.customQuestions.questions" contains "1" elements
    And Click on "common.questions.viewFirstQuestion"
    Then Element "div>div.Mui-expanded" should "exist"
    And Verify that element "chatbot.knowledgebase.questionTemplates.searchQuestionAnswer" has the following text "${searchQuestionTemplateAnswer}"

  Scenario: Filtering and Sorting Question Templates
    Given Login using random user from the list
      | chatbotLimited  |
      | chatbotStandard |
      | chatbotAdmin    |
    And Open chatbot "chatbotForAutomation"
    When Open "Chatbot->Knowledgebase->Question Templates" menu item
    And Click on "common.questions.filterResults"
    And Wait for element "chatbot.knowledgebase.questionTemplates.categoryLabel"
    And Click on "chatbot.knowledgebase.questionTemplates.categoryFilter"
    And Intercept "${DRUPAL_URL}/jsonapi/chatbot_question/chatbot_question?filter*" as "FilterRequest"
    And Click on tag "li" which contains text "Academic Calendar"
    And Wait for "FilterRequest" network call
    And Wait for element "chatbot.knowledgebase.questionTemplates.libraryLabel"
    And Click on "chatbot.knowledgebase.questionTemplates.libraryFilter"
    And Choose random value from "Financial Aid|Registrar" and save it as "LibraryFilter"
    And Intercept "${DRUPAL_URL}/jsonapi/chatbot_question/chatbot_question?filter*" as "FilterRequest"
    And Click on tag "li" which contains text "${LibraryFilter}"
    And Wait for "FilterRequest" network call
    Then Verify that page contains element "chatbot.knowledgebase.questionTemplates.filteredHeader" with text "Academic Calendar"
    And Verify that selector "chatbot.knowledgebase.questionTemplates.questionCount" contains more than "0" elements
    And Click on "common.questions.sortResults"
    And Choose random value from "Changed, Oldest to Most Recent|Changed, Recent to Oldest" and save it as "ordering"
    And Click on tag "li" which contains text "${ordering}"
    And Wait for "FilterRequest" network call
    Then Verify that page contains element "chatbot.knowledgebase.questionTemplates.filteredHeader" with text "${ordering}"
    And Verify that selector "chatbot.knowledgebase.questionTemplates.questionCount" contains more than "0" elements
