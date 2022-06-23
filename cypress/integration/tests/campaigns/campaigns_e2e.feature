Feature: Campaigns
  Before execution check that environment has:
  - provision number (see PROVISION_NUMBER env variable)
  - contact lists:
  -   ContactListForAutomation with 1 contact (513) 586-1971(first name: Message, second: Tool)
  -   ThreeContacts: (513) 586-1971, (970) 670-9874, 3rd contact should be opted out

  Background:
    Given Login as "campaignsAdmin"
    And Open chatbot "chatbotForAutomation"
    And Create random number and save it as "id"
    And Archive campaign which uses "${PROVISION_NUMBER}" number

  @exclude_from_ci
  Scenario: TMD-84: Binary campaigns - transcripts
  Test checks auto response and transcript
    When Create campaign
      | campaignName | Binary${id}              |
      | createFrom   | Scratch                  |
      | contentType  | binary                   |
      | contactList  | ContactListForAutomation |
      | office       | Office 1                 |
      | message      | Hi. Build ${id}          |
      | yesResponse  | Yep ${id}                |
      | number       | ${PROVISION_NUMBER}      |
      | campaignType | Bot                      |
    Then Verify that "(513) 586-1971" number "received" "Hi. Build ${id}" message
    When Send SMS "${randomYesResponse}" to "${PROVISION_NUMBER}" from "(513) 586-1971"
    Then Verify that "(513) 586-1971" number "received" "Yep ${id}" message

    When Open chatbot "chatbotForAutomation"
    And Open "Campaigns->Transcripts" menu item
    And Open the latest transcript

    Then Verify that page contains text "Hi. Build ${id}"
    And Verify that page contains text "${randomYesResponse}"
    And Verify that page contains text "Yep ${id}"

  @exclude_from_ci
  Scenario Outline: Binary campaigns - <test_name>
  Test checks 'yes' auto response, needs attention switch and statistics
    When Create campaign
      | campaignName        | Binary${id}              |
      | createFrom          | Scratch                  |
      | contentType         | binary                   |
      | contactList         | ContactListForAutomation |
      | office              | Office 1                 |
      | message             | Hi. Build ${id}          |
      | yesResponse         | Yep ${id}                |
      | number              | ${PROVISION_NUMBER}      |
      | campaignType        | Bot                      |
      | escalateYesResponse | <escalate_yes_response>  |
    Then Verify that "(513) 586-1971" number "received" "Hi. Build ${id}" message

    When Send SMS "${randomYesResponse}" to "${PROVISION_NUMBER}" from "(513) 586-1971"
    Then Verify that "(513) 586-1971" number "received" "Yep ${id}" message
    And Tag "p" with text "Needs Attention" should "<is_needs_attention_displayed>"

    When Click on tag "p" which contains text "<conversation_keyword>"
    And Click on "[title='Message Tool']"
    And Tag "span" with text "“YES” Response - " should "exist"

    When Intercept "${GRAPHQL_URL}graphql" with "getCampaignAnalytics" keyword in the response as "graphql"
    And Click on "[data-testid='Analytics-tab']"
    And Wait for "graphql" network call
    Then Verify that response "graphql" has field "response.body.data.getCampaignAnalytics.binaryResponses.yes" equal to "1"
    And Verify that response "graphql" has field "response.body.data.getCampaignAnalytics.binaryResponses.no" equal to "0"
    Examples:
      | test_name             | escalate_yes_response | is_needs_attention_displayed | conversation_keyword |
      | yes response          | no                    | not.exist                    | Bot-operated         |
      | escalate yes response | yes                   | exist                        | Needs Attention      |

  @exclude_from_ci
  Scenario Outline: Binary campaign - <test_name>
  Test checks 'no' auto response, needs attention switch and statistics
    When Create campaign
      | campaignName       | Binary${id}              |
      | createFrom         | Scratch                  |
      | contentType        | binary                   |
      | contactList        | ContactListForAutomation |
      | office             | Office 1                 |
      | message            | Hi. Build ${id}          |
      | noResponse         | Nope ${id}               |
      | number             | ${PROVISION_NUMBER}      |
      | campaignType       | Bot                      |
      | escalateNoResponse | <escalate_no_response>   |

    Then Verify that "(513) 586-1971" number "received" "Hi. Build ${id}" message

    When Send SMS "${randomNoResponse}" to "${PROVISION_NUMBER}" from "(513) 586-1971"
    Then Verify that "(513) 586-1971" number "received" "Nope ${id}" message
    And Tag "p" with text "Needs Attention" should "<is_needs_attention_displayed>"

    When Click on tag "p" which contains text "<conversation_keyword>"
    And Click on "[title='Message Tool']"
    And Tag "span" with text "“NO” Response - " should "exist"
    And Tag "p" with text "Hi. Build ${id}" should "exist"
    And Tag "div" with text "${randomNoResponse}" should "exist"
    And Tag "p" with text "Nope ${id}" should "exist"

    When Intercept "${GRAPHQL_URL}graphql" with "getCampaignAnalytics" keyword in the response as "graphql"
    And Click on "[data-testid='Analytics-tab']"
    And Wait for "graphql" network call
    Then Verify that response "graphql" has field "response.body.data.getCampaignAnalytics.binaryResponses.yes" equal to "0"
    And Verify that response "graphql" has field "response.body.data.getCampaignAnalytics.binaryResponses.no" equal to "1"
    Examples:
      | test_name            | escalate_no_response | is_needs_attention_displayed | conversation_keyword |
      | no response          | no                   | not.exist                    | Bot-operated         |
      | escalate no response | yes                  | exist                        | Needs Attention      |

  Scenario: Binary campaign - other response
    When Create campaign
      | campaignName | Binary${id}         |
      | createFrom   | Scratch             |
      | contentType  | binary              |
      | contactList  | ThreeContacts       |
      | office       | Office 1            |
      | message      | Hi. Build ${id}     |
      | yesResponse  | Yep ${id}           |
      | noResponse   | Nope ${id}          |
      | number       | ${PROVISION_NUMBER} |
      | campaignType | Bot                 |

    Then Verify that "(513) 586-1971" number "received" "Hi. Build ${id}" message
    And Verify that "(970) 670-9874" number "received" "Hi. Build ${id}" message
    And Verify that "(970) 594-8337" number "not.received" "Hi. Build ${id}" message

    When Send SMS "Other response ${id}" to "${PROVISION_NUMBER}" from "(513) 586-1971"
    And Tag "p" with text "Needs Attention" should "exist"

    When Click on tag "p" which contains text "Needs Attention"
    And Click on "[title='Message Tool']"
    And Tag "span" with text "“OTHER” Response - " should "exist"
    And Tag "p" with text "Hi. Build ${id}" should "exist"
    And Tag "div" with text "Other response ${id}" should "exist"

    # uncomment when NUG-1497 will be resolved
    # And Verify that last SMS for number "(513) 586-1971" has text "Hi. Build ${id}"

    When Intercept "${GRAPHQL_URL}graphql" with "getCampaignAnalytics" keyword in the response as "graphql"
    And Click on "[data-testid='Analytics-tab']"
    And Wait for "graphql" network call
    Then Verify that response "graphql" has field "response.body.data.getCampaignAnalytics.binaryResponses.yes" equal to "0"
    And Verify that response "graphql" has field "response.body.data.getCampaignAnalytics.binaryResponses.no" equal to "0"
    And Verify that response "graphql" has field "response.body.data.getCampaignAnalytics.binaryResponses.other" equal to "1"
    And Verify that response "graphql" has field "response.body.data.getCampaignAnalytics.binaryResponses.noResponse" equal to "2"

  Scenario: Simple campaign - bot operated, IDK response
  Bot operated campaign should notify user about 'waiting for an operator' for IDK responses
    When Create campaign
      | campaignName | Simple${id}               |
      | createFrom   | Scratch                   |
      | contentType  | simple                    |
      | contactList  | ContactListForAutomation  |
      | office       | Office 1                  |
      | message      | Hi. Simple campaign ${id} |
      | number       | ${PROVISION_NUMBER}       |
      | campaignType | Bot                       |
      | idkType      | Agent                     |
    Then Verify that "(513) 586-1971" number "received" "Hi. Simple campaign ${id}" message
    When Send SMS "${IDK_QUESTION}" to "${PROVISION_NUMBER}" from "(513) 586-1971"
    Then Verify that "(513) 586-1971" number "received" "${IDK_AUTO_RESPONSE}" message

    When Click on tag "p" which contains text "Needs Attention"
    And Click on "[title='Message Tool']"
    And Type "Operator is here ${id}" in "campaigns.active.responseInput"
    And Wait "1000"
    And Click on tag "span.MuiButton-label" which contains text "Send"

    Then Verify that "(513) 586-1971" number "received" "Operator is here ${id}" message
