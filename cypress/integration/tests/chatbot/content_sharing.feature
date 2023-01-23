Feature: Chatbot - Content Sharing

  Scenario: Child bot can't delete shared question
    Given Login as "chatbotAdmin"
    And Open chatbot "chatbotForInquiryForm"
    When Open "Chatbot->Knowledgebase->Custom Questions" menu item
    And Find "${parentCustomQuestion2}"
    And Verify that selector "chatbot.knowledgebase.customQuestions.questions" contains "1" elements
    And Verify that element "chatbot.knowledgebase.customQuestions.selectedQuestion" has the following text "${parentCustomQuestion2}"
    And Click on "common.questions.viewFirstQuestion"
    Then Tag "button" with text "Delete" should "not.exist"

  Scenario: Unsharing question removes question from child bots
    Given Login as "chatbotAdmin"
    And Open chatbot "chatbotForAutomation"

    When Open "Chatbot->Knowledgebase->Custom Questions" menu item
    And Find "${parentCustomQuestion1}"
    And Verify that element "chatbot.knowledgebase.customQuestions.selectedQuestion" has the following text "${parentCustomQuestion1}"
    And Click on "common.questions.viewFirstQuestion"
    And Click on tag "button" which contains text "Edit"
    And Set content sharing switch to "enabled"
    And Verify that element "chatbot.knowledgebase.customQuestions.contactLockBtn" has attribute "value" with value "true"
    And Click on "chatbot.knowledgebase.customQuestions.questionSaveButton"

    Then Open chatbot "chatbotForInquiryForm"
    And Open "Chatbot->Knowledgebase->Custom Questions" menu item
    And Find "${parentCustomQuestion1}"
    And Verify that element "chatbot.knowledgebase.customQuestions.selectedQuestion" has the following text "${parentCustomQuestion1}"
    And Verify that selector "chatbot.knowledgebase.customQuestions.shareIcon" contains "1" elements

    When Open chatbot home page
    And Open "Chatbot->Knowledgebase->Custom Questions" menu item
    And Type "${parentCustomQuestion1}" in "common.questions.searchQuestion"
    And Verify that element "chatbot.knowledgebase.customQuestions.selectedQuestion" has the following text "${parentCustomQuestion1}"
    And Click on "common.questions.viewFirstQuestion"
    And Click on tag "button" which contains text "Edit"
    And Set content sharing switch to "disabled"
    And Click on "chatbot.knowledgebase.customQuestions.questionSaveButton"

    Then Open chatbot "chatbotForInquiryForm"
    And Open "Chatbot->Knowledgebase->Custom Questions" menu item
    And Find "${parentCustomQuestion1}"
    And Tag "p.CustomQuestion-heading" with text "${parentCustomQuestion1}" should "not.exist"
    And Element "chatbot.knowledgebase.customQuestions.shareIcon" should "not.exist"
