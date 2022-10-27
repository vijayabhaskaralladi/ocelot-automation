Feature: chatbot - Content Sharing

  Scenario: Child bot can't delete shared question
    Given Login as "chatbotAdmin"
    And Open chatbot "chatbotForInquiryForm"
    When Open "Chatbot->Knowledgebase->Custom Questions" menu item
    And Type "${parentCustomQuestion2}" in "chatbot.knowledgebase.customQuestions.search"
    And Verify that selector "chatbot.knowledgebase.customQuestions.questions" contains "1" elements
    And Verify that element "chatbot.knowledgebase.customQuestions.selectedQuestion" has the following text "${parentCustomQuestion2}"
    And Click on "chatbot.knowledgebase.customQuestions.viewFirstQuestion"
    Then Tag "span.MuiButton-label" with text "Delete" should "not.exist"

  Scenario: Unsharing question removes question from child bots
    Given Login as "chatbotAdmin"
    And Open chatbot "chatbotForAutomation"

    When Open "Chatbot->Knowledgebase->Custom Questions" menu item
    And Type "${parentCustomQuestion1}" in "chatbot.knowledgebase.customQuestions.search"
    And Verify that element "chatbot.knowledgebase.customQuestions.selectedQuestion" has the following text "${parentCustomQuestion1}"
    And Click on "chatbot.knowledgebase.customQuestions.viewFirstQuestion"
    And Click on tag "span" which contains text "Edit"
    And Set content sharing switch to "enabled"
    And Verify that element "chatbot.knowledgebase.customQuestions.contactLockBtn" has attribute "value" with value "true"
    And Click on "chatbot.knowledgebase.customQuestions.questionSaveButton"

    Then Open chatbot "chatbotForInquiryForm"
    And Open "Chatbot->Knowledgebase->Custom Questions" menu item
    And Type "${parentCustomQuestion1}" in "chatbot.knowledgebase.customQuestions.search"
    And Verify that element "chatbot.knowledgebase.customQuestions.selectedQuestion" has the following text "${parentCustomQuestion1}"

    When Open chatbot "chatbotForAutomation"
    And Open "Chatbot->Knowledgebase->Custom Questions" menu item
    And Type "${parentCustomQuestion1}" in "chatbot.knowledgebase.customQuestions.search"
    And Verify that element "chatbot.knowledgebase.customQuestions.selectedQuestion" has the following text "${parentCustomQuestion1}"
    And Click on "chatbot.knowledgebase.customQuestions.viewFirstQuestion"
    And Click on tag "span" which contains text "Edit"
    And Set content sharing switch to "disabled"
    And Click on "chatbot.knowledgebase.customQuestions.questionSaveButton"

    Then Open chatbot "chatbotForInquiryForm"
    And Open "Chatbot->Knowledgebase->Custom Questions" menu item
    And Type "${parentCustomQuestion1}" in "chatbot.knowledgebase.customQuestions.search"
    And Tag "p.MuiTypography-body1" with text "${parentCustomQuestion1}" should "not.exist"
