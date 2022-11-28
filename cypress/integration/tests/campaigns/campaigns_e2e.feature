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
    And Save "(513) 586-1971" as "firstContact"
    And Save "(970) 670-9874" as "secondContact"
    And Save "(970) 594-8337" as "optedOutContact"
    And Save "campaigns@automation.com" as "firstContactEmail"

  Scenario: TMD-84: Binary campaigns - transcripts
  Test checks auto response and transcript
    Given Archive campaign which uses "${PROVISION_NUMBER}" number
    When Create campaign
      | campaignName     | Binary${id}              |
      | createFrom       | Scratch                  |
      | contentType      | binary                   |
      | contactList      | ContactListForAutomation |
      | office           | Office 1                 |
      | message          | Hi. Build ${id}          |
      | yesResponse      | Yep ${id}                |
      | number           | ${PROVISION_NUMBER}      |
      | automaticArchive | 1 day                    |
      | campaignType     | Bot                      |
    Then Verify that "${firstContact}" number "received" "Hi. Build ${id}" message
    And Wait "4000"
    When Send SMS "${randomYesResponse}" to "${PROVISION_NUMBER}" from "${firstContact}"
    Then Verify that "${firstContact}" number "received" "Yep ${id}" message

    When Open chatbot "chatbotForAutomation"
    And Open "Texting->Transcripts" menu item
    And Open the latest transcript
    Then Verify that page contains text "Hi. Build ${id}"
    And Verify that page contains text "${randomYesResponse}"
    And Verify that page contains text "Yep ${id}"

    When Click on tag "h6" which contains text "Conversation Details"
    And Save current date as "date" using "yyyy-mm-dd" format
    Then Tag ".Mui-expanded div" with text "${date}" should "exist"

    #ToDo: uncomment these steps when 'Phone Numbers' page will contain 'Archive Date' column
    #When Open chatbot "chatbotForAutomation"
    #And Open "Texting->Phone Numbers" menu item
    #And Type "${PROVISION_NUMBER}" in "texting.phoneNumbers.searchInput"
    #And Verify that selector "texting.phoneNumbers.records" contains "1" elements
    #And Save current month as "month"
    #And Save current year as "year"
    #Then Verify that page contains element "texting.phoneNumbers.archiveDate" with text "${month}"
    #And Verify that page contains element "texting.phoneNumbers.archiveDate" with text "${year}"

  Scenario Outline: Binary campaigns - <test_name>
  Test checks 'yes' auto response, needs attention switch and statistics
    Given Archive campaign which uses "${PROVISION_NUMBER}" number
    When Create campaign
      | campaignName        | Binary${id}              |
      | createFrom          | Scratch                  |
      | contentType         | binary                   |
      | contactList         | ContactListForAutomation |
      | office              | Office 1                 |
      | message             | Hi. Build ${id}          |
      | yesResponse         | Yep ${id}                |
      | number              | ${PROVISION_NUMBER}      |
      | automaticArchive    | 1 day                    |
      | campaignType        | Bot                      |
      | escalateYesResponse | <escalate_yes_response>  |
    Then Verify that "${firstContact}" number "received" "Hi. Build ${id}" message
    And Wait "4000"
    When Send SMS "${randomYesResponse}" to "${PROVISION_NUMBER}" from "${firstContact}"
    Then Verify that "${firstContact}" number "received" "Yep ${id}" message
    And Tag "p" with text "Needs Attention" should "<is_needs_attention_displayed>"
    And Refresh the page
    When Click on tag "p" which contains text "<conversation_keyword>"
    And Click on tag "div" which contains text "Message Tool"
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

  Scenario Outline: Binary campaign - <test_name>
  Test checks 'no' auto response, needs attention switch and statistics
    Given Archive campaign which uses "${PROVISION_NUMBER}" number
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
      | automaticArchive   | 1 day                    |
      | escalateNoResponse | <escalate_no_response>   |

    Then Verify that "${firstContact}" number "received" "Hi. Build ${id}" message
    And Wait "4000"
    When Send SMS "${randomNoResponse}" to "${PROVISION_NUMBER}" from "${firstContact}"
    Then Verify that "${firstContact}" number "received" "Nope ${id}" message
    And Tag "p" with text "Needs Attention" should "<is_needs_attention_displayed>"

    And Refresh the page
    When Click on tag "p" which contains text "<conversation_keyword>"
    And Click on tag "div" which contains text "Message Tool"
    And Tag "span" with text "“NO” Response - " should "exist"
    And Tag "p" with text "Hi. Build ${id}" should "exist"
    And Tag "div" with text "${randomNoResponse}" should "exist"
    And Tag "p" with text "Nope ${id}" should "exist"

    And Click on tag "h6" which contains text "Conversation Details"
    And Tag "div" with text "${firstContactEmail}" should "exist"
    And Tag "div" with text "${firstContact}" should "exist"
    And Tag "div" with text "+1 ${PROVISION_NUMBER}" should "exist"

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
    Given Archive campaign which uses "${PROVISION_NUMBER}" number
    When Create campaign
      | campaignName     | Binary${id}         |
      | createFrom       | Scratch             |
      | contentType      | binary              |
      | contactList      | ThreeContacts       |
      | office           | Office 1            |
      | message          | Hi. Build ${id}     |
      | yesResponse      | Yep ${id}           |
      | noResponse       | Nope ${id}          |
      | number           | ${PROVISION_NUMBER} |
      | automaticArchive | 1 day               |
      | campaignType     | Bot                 |

    Then Verify that "${firstContact}" number "received" "Hi. Build ${id}" message
    And Verify that "${secondContact}" number "received" "Hi. Build ${id}" message
    And Verify that "${optedOutContact}" number "not.received" "Hi. Build ${id}" message
    And Wait "4000"

    When Send SMS "Other response ${id}" to "${PROVISION_NUMBER}" from "${firstContact}"
    And Tag "p" with text "Needs Attention" should "exist"
    And Refresh the page
    When Click on tag "p" which contains text "Needs Attention"
    And Click on tag "div" which contains text "Message Tool"
    And Tag "span" with text "“OTHER” Response - " should "exist"
    And Tag "p" with text "Hi. Build ${id}" should "exist"
    And Tag "div" with text "Other response ${id}" should "exist"

    And Type "Second Message ${id}" in "texting.activeCampaigns.responseInput"
    And Wait "1000"
    And  Click on tag "button.MuiButtonBase-root" which contains text "Send"
    Then Verify that "${firstContact}" number "received" "Second Message ${id}" message

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
    Given Archive campaign which uses "${PROVISION_NUMBER}" number
    When Create campaign
      | campaignName     | Simple${id}               |
      | createFrom       | Scratch                   |
      | contentType      | simple                    |
      | contactList      | ContactListForAutomation  |
      | office           | Office 1                  |
      | message          | Hi. Simple campaign ${id} |
      | number           | ${PROVISION_NUMBER}       |
      | campaignType     | Bot                       |
      | automaticArchive | 1 day                     |
      | idkType          | Agent                     |
    Then Verify that "${firstContact}" number "received" "Hi. Simple campaign ${id}" message
    When Send SMS "${IDK_QUESTION}" to "${PROVISION_NUMBER}" from "${firstContact}"
    Then Verify that "${firstContact}" number "received" "${IDK_AUTO_RESPONSE}" message

    And Refresh the page
    When Click on tag "p" which contains text "Needs Attention"
    And Click on tag "div" which contains text "Message Tool"
    And Type "Operator is here ${id}" in "texting.activeCampaigns.responseInput"
    And Wait "1000"
    And Click on tag "button.MuiButtonBase-root" which contains text "Send"

    Then Verify that "${firstContact}" number "received" "Operator is here ${id}" message

  Scenario: Sending messages to archived campaign
  Test creates and ends campaign. Then it sends message to this campaign and checks inbox.
    Given Archive campaign which uses "${PROVISION_NUMBER}" number
    When Create campaign
      | campaignName     | Simple${id}               |
      | createFrom       | Scratch                   |
      | contentType      | simple                    |
      | contactList      | ContactListForAutomation  |
      | office           | Office 1                  |
      | message          | Hi. Simple campaign ${id} |
      | number           | ${PROVISION_NUMBER}       |
      | campaignType     | Bot                       |
      | automaticArchive | 1 day                     |
      | idkType          | Agent                     |
    Then Verify that "${firstContact}" number "received" "Hi. Simple campaign ${id}" message
    And Send SMS "Hi. Campaign ${id}" to "${PROVISION_NUMBER}" from "${firstContact}"
    And Click on tag "button" which contains text "End campaign"
    Then Click on tag "button" which contains text "Confirm"
    When Send SMS "Hi. inbox ${id}" to "${PROVISION_NUMBER}" from "${firstContact}"
    And Open chatbot "chatbotForAutomation"
    Then Open "Inbox" menu item
    And Tag "ul.MuiList-root" with text "Hi. inbox ${id}" should "exist"

    #testing filter
    When Click on "inbox.conversationsFilter"
    And Intercept "${GRAPHQL_URL}graphql" with "inboxFilterConversations" keyword in the response as "filterRequest"
    And Click on tag "li.MuiMenuItem-root" which contains text "No Campaigns"
    Then Wait for "filterRequest" and save it as "filterResponse"
    And Verify that response "filterResponse" has status code "200"
    And Tag "ul.MuiList-root" with text "Hi. Campaign ${id}" should "not.exist"

  Scenario: Campaigns Analytics
  Verify that Launching a Campaign Changes the count on Campaign Analytics
    Given Archive campaign which uses "${PROVISION_NUMBER_OFFICE2}" number
    When Open "Texting->Campaign Analytics" menu item
    And Wait for element "texting.campaignAnalytics.contactResponsesPerHourChart"
    And Retrieve text from "texting.campaignAnalytics.contactsMessaged" and save as "oldContactsMessaged"
    And Retrieve text from "texting.campaignAnalytics.contactsResponded" and save as "oldContactsResponded"
    When Create campaign
      | campaignName       | Binary${id}                 |
      | createFrom         | Scratch                     |
      | contentType        | binary                      |
      | contactList        | ThreeContacts               |
      | office             | Office 2                    |
      | message            | Hi. Build ${id}             |
      | noResponse         | Nope ${id}                  |
      | number             | ${PROVISION_NUMBER_OFFICE2} |
      | campaignType       | Bot                         |
      | automaticArchive   | 1 day                       |
      | escalateNoResponse | no                          |
    Then Verify that "${firstContact}" number "received" "Hi. Build ${id}" message
    And Wait "4000"
    When Send SMS "${randomNoResponse}" to "${PROVISION_NUMBER_OFFICE2}" from "${firstContact}"
    And Open chatbot "chatbotForAutomation"
    When Open "Texting->Campaign Analytics" menu item
    And Wait for element "texting.campaignAnalytics.contactResponsesPerHourChart"
    And Retrieve text from "texting.campaignAnalytics.contactsMessaged" and save as "newContactsMessaged"
    And Retrieve text from "texting.campaignAnalytics.contactsResponded" and save as "newContactsResponded"
    And Tag "p" with text "Binary${id}" should "exist"
    And Check that difference between "newContactsMessaged" and "oldContactsMessaged" is "2"
    And Check that difference between "newContactsResponded" and "oldContactsResponded" is "1"

    When Intercept "${GRAPHQL_URL}graphql" with "getAnalyticCampaigns" keyword in the response as "searchRequest"
    And Click on "texting.campaignAnalytics.filter"
    And Wait for element "texting.campaignAnalytics.officeStatus"
    And Click on "texting.campaignAnalytics.officeStatus"
    And Click on tag "li" which contains text "Office 2"
    And Wait for "searchRequest" and save it as "searchResponse"
    Then Verify that response "searchResponse" has status code "200"
    And Tag "p" with text "Binary${id}" should "exist"

    When Click on tag "li" which contains text "Office 2"
    And Click on tag "li" which contains text "Office 1"
    And Wait for "searchRequest" and save it as "searchResponse"
    Then Verify that response "searchResponse" has status code "200"
    And Tag "p" with text "Binary${id}" should "not.exist"