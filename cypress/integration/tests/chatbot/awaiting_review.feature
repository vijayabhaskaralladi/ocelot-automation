Feature: Permissions - awaiting review

  Scenario: Viewing Awaiting Review questions
    # This test requires question "Question for 'Awaiting Review' test" with correct review date;
    # We update this date manually for now, it will be replaced with API call in the future
    Given Login using random user from the list
      | chatbotStandard         |
      | chatbotAdmin            |
      | viewOtherOfficesChatbot |
    And Open chatbot "chatbotForAutomation"
    When Open "Chatbot->Knowledgebase->Awaiting Review" menu item
    Then Tag "p" with text "${awaitingReviewQuestion}" should "exist"

  Scenario: Verify that limited user can't view Awaiting Review
    Given Login as "chatbotLimited"
    And Open chatbot "chatbotForAutomation"
    When Open "Chatbot->Knowledgebase" menu item
    Then Tag "li>a" with text "Awaiting Review" should "not.exist"

  Scenario: Editing Awaiting Review questions
    Verify that editing an Awaiting review question does not remove the same question from Awaiting review page.
    Given Login using random user from the list
      | chatbotStandard         |
      | chatbotAdmin            |
      | viewOtherOfficesChatbot |
    And Open chatbot "chatbotForAutomation"
    When Open "Chatbot->Knowledgebase->Awaiting Review" menu item
    And Type "${awaitingReviewQuestion}" in "chatbot.knowledgebase.awaitingReview.searchQuestion"
    And Verify that element "chatbot.knowledgebase.awaitingReview.firstRowAwaitingQuestion" has the following text "${awaitingReviewQuestion}"
    And Click on "chatbot.knowledgebase.awaitingReview.viewFirstAwaitingQuestion"
    And Create random number and save it as "random"
    And Click on tag "button" which contains text "Edit"
    And Type "RandomText${random}" in "chatbot.knowledgebase.awaitingReview.editAwaitingResponse"
    And Click on tag "button" which contains text "Save"
    And Verify that page contains text "Your question has been successfully published"
    And Type "${awaitingReviewQuestion}" in "chatbot.knowledgebase.awaitingReview.searchQuestion"
    And Verify that element "chatbot.knowledgebase.awaitingReview.firstRowAwaitingQuestion" has the following text "${awaitingReviewQuestion}"

