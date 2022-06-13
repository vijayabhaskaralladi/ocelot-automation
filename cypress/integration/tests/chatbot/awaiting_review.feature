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

  Scenario Outline: Verify that user <user_name> can't view Awaiting Review
    Given Login as "<user_name>"
    And Open chatbot "chatbotForAutomation"
    When Open "Chatbot->Knowledgebase" menu item
    Then Tag "span.MuiButton-label" with text "Awaiting Review" should "not.exist"
    Examples:
      | user_name               |
      | chatbotLimited          |
