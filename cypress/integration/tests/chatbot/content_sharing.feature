Feature: chatbot - Content Sharing

  Scenario: Child bot can't delete shared question
    Given Login as "chatbotAdmin"
    And Open chatbot "chatbotForInquiryForm"
    When Open "Chatbot->Knowledgebase->Custom Questions" menu item
    And Type "${parentCustomQuestion}" in "chatbot.knowledgebase.customQuestions.search"
    And Verify that selector "chatbot.knowledgebase.customQuestions.questions" contains "1" elements
    And Verify that element "chatbot.knowledgebase.customQuestions.selectedQuestion" contains the following text "${parentCustomQuestion}"
    And Click on "chatbot.knowledgebase.customQuestions.viewFirstQuestion"
    Then Tag "span.MuiButton-label" with text "Delete" should "not.exist"

  @exclude_from_ci
    Scenario: Unsharing question removes question from child bots
      Given Login as "chatbotAdmin"
      And Open chatbot "chatbotForAutomation"
      When Open "Chatbot->Knowledgebase->Custom Questions" menu item
      And Type "${parentGeneralQuestion}" in "chatbot.knowledgebase.customQuestions.search"
      And Verify that element "chatbot.knowledgebase.customQuestions.selectedQuestion" contains the following text "${parentGeneralQuestion}"
      And Click on "chatbot.knowledgebase.customQuestions.viewFirstQuestion"
      And Click on tag "span" which contains text "Edit"
      And Set content sharing switch to "enabled"
      And Click on "chatbot.knowledgebase.customQuestions.questionSaveButton"

      And Open chatbot "chatbotForInquiryForm"
      When Open "Chatbot->Knowledgebase->Custom Questions" menu item
      And Type "${parentGeneralQuestion}" in "chatbot.knowledgebase.customQuestions.search"
      And Verify that element "chatbot.knowledgebase.customQuestions.selectedQuestion" contains the following text "${parentGeneralQuestion}"

      And Open chatbot "chatbotForAutomation"
      When Open "Chatbot->Knowledgebase->Custom Questions" menu item
      And Type "${parentGeneralQuestion}" in "chatbot.knowledgebase.customQuestions.search"
      And Verify that element "chatbot.knowledgebase.customQuestions.selectedQuestion" contains the following text "${parentGeneralQuestion}"
      And Click on "chatbot.knowledgebase.customQuestions.viewFirstQuestion"
      And Click on tag "span" which contains text "Edit"
      And Set content sharing switch to "disabled"
      And Click on "chatbot.knowledgebase.customQuestions.questionSaveButton"

      And Open chatbot "chatbotForInquiryForm"
      When Open "Chatbot->Knowledgebase->Custom Questions" menu item
      And Type "${parentGeneralQuestion}" in "chatbot.knowledgebase.customQuestions.search"
      Then Tag "p.MuiTypography-body1" with text "${parentGeneralQuestion}" should "not.exist"
