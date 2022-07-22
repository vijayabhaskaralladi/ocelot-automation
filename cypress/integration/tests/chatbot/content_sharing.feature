Feature: chatbot - Content Sharing

  Scenario: Child bot can't delete shared question
    Given Login as "chatbotAdmin"
    And Open chatbot "chatbotForInquiryForm"
    When Open "Chatbot->Knowledgebase->Custom Questions" menu item
    And Type "${parentCustomQuestion}" in "chatbot.knowledgebase.customQuestions.search"
    Then Tag "p.MuiTypography-body1" with text "${parentCustomQuestion}" should "exist"
    And Click on "chatbot.knowledgebase.customQuestions.viewFirstQuestion"
    Then Tag "span.MuiButton-label" with text "Delete" should "not.exist"