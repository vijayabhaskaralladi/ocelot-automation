Feature: 1:1 messages

  Scenario: Sending messages
  Provision number should have 'Agent' response type; also don't forget to add inbox
    Given Login as "campaignsAdmin"
    And Open chatbot "chatbotForAutomation"
    And Create random number and save it as "id"
    And Save "(513) 447-6784" as "studentNumber"

    When Send 1:1 message
      | message | Hi! Test ${id}      |
      | to      | ${studentNumber}    |
      | from    | ${PROVISION_NUMBER} |
    Then Verify that "${studentNumber}" number "received" "Hi! Test ${id}" message

    When Send SMS "1:1 response ${id}" to "${PROVISION_NUMBER}" from "${studentNumber}"
    # client admin automatically opens Inbox page after receiving message
    Then Verify that page contains text "Hi! Test ${id}"

    When Click on tag "h6" which contains text "Conversation Details"
    Then Tag ".MuiAccordionDetails-root>div>div" with text "${studentNumber}" should "exist"
    And Tag ".MuiAccordionDetails-root>div>div" with text "${PROVISION_NUMBER}" should "exist"

  Scenario: Verify that sending message to Opted Out Contact should not receive any messages
    Given Login as "campaignsAdmin"
    And Open chatbot "chatbotForAutomation"
    And Create random number and save it as "id"
    And Save "(970) 594-8337" as "optedOutNumber"
    When Send 1:1 message
      | message | Hey! Test ${id}     |
      | to      | ${optedOutNumber}   |
      | from    | ${PROVISION_NUMBER} |
    Then Check that notification message "Failed to send. Phone number opted out." appeared
    And Verify that "${optedOutNumber}" number "not.received" "Hey! Test ${id}" message
