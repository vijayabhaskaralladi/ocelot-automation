Feature: 1:1 messages

  Scenario: Sending messages
  Provision number should have 'Agent' response type; also don't forget to add inbox
    Given Login as "campaignsAdmin"
    And Open chatbot "chatbotForAutomation"
    And Create random number and save it as "id"
    And Save "(513) 447-6784" as "studentNumber"

    When Send 1:1 message
      | message | Hey! Test ${id}     |
      | to      | ${studentNumber}    |
      | from    | ${PROVISION_NUMBER} |
    Then Verify that "${studentNumber}" number "received" "Hey! Test ${id}" message

    When Send SMS "1:1 response ${id}" to "${PROVISION_NUMBER}" from "${studentNumber}"
    Then Verify that page contains text "Hey! Test ${id}"

  Scenario: Verify that sending message to Opted Out Contact should not receive any messages
    Given Login as "campaignsAdmin"
    And Open chatbot "chatbotForAutomation"
    And Create random number and save it as "id"
    And Save "(513) 447-6784" as "optedOutNumber"
    When Send 1:1 message
      | message | Hey! Test ${id}     |
      | to      | ${optedOutNumber}    |
      | from    | ${PROVISION_NUMBER} |
    Then Tag "#notistack-snackbar" with text "Failed to send. Phone number opted out." should "exist"
    And Verify that "${optedOutNumber}" number "not.received" "Hey! Test ${id}" message
