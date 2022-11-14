Feature: Permissions - question templates

  Scenario: Viewing Question Templates
    Given Login using random user from the list
      | chatbotLimited          |
      | chatbotStandard         |
      | chatbotAdmin            |
      | viewOtherOfficesChatbot |
    And Open chatbot "chatbotForAutomation"
    When Open "Chatbot->Knowledgebase->Question Templates" menu item
    And Click on "chatbot.knowledgebase.generalLibrary.viewFirstQuestion"
    Then Element "div.Mui-expanded>div.MuiCollapse-entered" should "exist"

  Scenario: Searching Question Templates
    Given Login using random user from the list
      | chatbotLimited          |
      | chatbotStandard         |
      | chatbotAdmin            |
      | viewOtherOfficesChatbot |
    And Open chatbot "chatbotForAutomation"
    When Open "Chatbot->Knowledgebase->Question Templates" menu item
    And Type "${searchQuestionTemplate}" in "chatbot.knowledgebase.customQuestions.search"
    And Verify that selector "chatbot.knowledgebase.customQuestions.questions" contains "1" elements
    And Click on "chatbot.knowledgebase.generalLibrary.viewFirstQuestion"
    Then Element "div.Mui-expanded>div.MuiCollapse-entered" should "exist"
    And Verify that element "chatbot.knowledgebase.questionTemplates.searchQuestionAnswer" has the following text "${searchQuestionTemplateAnswer}"

  Scenario: Filtering and Sorting Question Templates
    Given Login using random user from the list
      | chatbotLimited  |
      | chatbotStandard |
      | chatbotAdmin    |
    And Open chatbot "chatbotForAutomation"
    When Open "Chatbot->Knowledgebase->Question Templates" menu item
    And Click on "chatbot.knowledgebase.questionTemplates.filterQuestion"
    And Wait for element "chatbot.knowledgebase.questionTemplates.deptLabel"
    And Click on "chatbot.knowledgebase.questionTemplates.deptFilter"
    And Choose random value from "Academic Advising|Admissions|Athletics" and save it as "DepartmentFilter"
    And Intercept "${DRUPAL_URL}/jsonapi/chatbot_question/chatbot_question?filter*" as "FilterRequest"
    And Click on tag "li" which contains text "${DepartmentFilter}"
    And Wait for "FilterRequest" network call
    Then Verify that page contains element "chatbot.knowledgebase.questionTemplates.filteredHeader" with text "${DepartmentFilter}"
    And Verify that selector "chatbot.knowledgebase.questionTemplates.questionCount" contains more than "5" elements
    And Click on "chatbot.knowledgebase.questionTemplates.buttonSort"
    And Choose random value from "Changed, Oldest to Most Recent|Changed, Recent to Oldest" and save it as "ordering"
    And Click on tag "li" which contains text "${ordering}"
    And Wait for "FilterRequest" network call
    Then Verify that page contains element "chatbot.knowledgebase.questionTemplates.filteredHeader" with text "${ordering}"
    And Verify that selector "chatbot.knowledgebase.questionTemplates.questionCount" contains more than "5" elements