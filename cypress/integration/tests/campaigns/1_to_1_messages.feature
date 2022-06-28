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
