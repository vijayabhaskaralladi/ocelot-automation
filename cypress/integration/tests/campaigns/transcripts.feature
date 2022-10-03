Feature: Permissions - campaigns transcripts

  Scenario: Exporting Campaigns Transcripts
  Test expects that transcripts contain at least 1 campaign conversation with name 'Binary*'
    Given Login using random user from the list
      | campaignsStandard         |
      | campaignsAdmin            |
      | viewOtherOfficesCampaigns |
    And Open chatbot "chatbotForAutomation"
    When Open "Texting->Transcripts" menu item
    And Add reload event listener
    And Click on "texting.transcripts.exportTranscripts"
    Then Verify that download folder contains "campaign-transcripts.csv"
    And Verify that file "campaign-transcripts.csv" from download folder contains text "operatedBy"
    And Verify that file "campaign-transcripts.csv" from download folder contains text "bot"
    And Verify that file "campaign-transcripts.csv" from download folder contains text "Binary"

  Scenario: Viewing Campaigns Transcripts and filter by read/unread status
    Given Login using random user from the list
      | campaignsStandard         |
      | campaignsAdmin            |
      | viewOtherOfficesCampaigns |
    And Open chatbot "chatbotForAutomation"
    When Open "Texting->Transcripts" menu item
    Then Verify that browser tab title contains "Transcripts"
    And Intercept "${GRAPHQL_URL}graphql" with "GetCampaignTranscriptList" keyword in the response as "searchRequest"
    And Click on "texting.transcripts.filterResults"
    And Click on "texting.transcripts.readStatusFilter"
    And Click on "texting.transcripts.unReadFilter"
    And Wait for "searchRequest" network call
    And Verify that element "texting.transcripts.unreadFilterName" has the following text "Read Status: Unread"
    And Verify that selector "texting.transcripts.transcriptListTable" contains more than "1" elements

  Scenario Outline: Verify that user <user_name> can't see Campaigns Transcripts
    Given Login as "<user_name>"
    And Open chatbot "chatbotForAutomation"
    And Open "Texting" menu item
    Then Tag "span.MuiButton-label" with text "Transcripts" should "not.exist"
    Examples:
      | user_name        |
      | campaignsLimited |

  Scenario: Verify that user can mark transcripts Read/Unread in a campaign
    Given Login using random user from the list
      | campaignsStandard |
      | campaignsAdmin    |
    And Open chatbot "chatbotForAutomation"
    And Open "Texting->Transcripts" menu item
    And URL should include "campaigns/transcripts"
    And Add "?readStatus=Read&startDate=2022-05-05" to the current URL

    When Intercept "${GRAPHQL_URL}graphql" with "setCampaignTranscriptReadStatus" keyword in the response as "markTranscriptAsRead"
    And Click on "texting.transcripts.readStatusButtonFirstRow"
    And Wait for "markTranscriptAsRead" network call
    Then Verify that response "markTranscriptAsRead" has status code "200"
    And Verify that element "texting.transcripts.readStatusButtonFirstRow" has attribute "aria-label" with value "Mark Read"

    When Intercept "${GRAPHQL_URL}graphql" with "setCampaignTranscriptReadStatus" keyword in the response as "markTranscriptAsUnread"
    And Click on "texting.transcripts.readStatusButtonFirstRow"
    And Wait for "markTranscriptAsUnread" network call
    Then Verify that response "markTranscriptAsUnread" has status code "200"
    And Verify that element "texting.transcripts.readStatusButtonFirstRow" has attribute "aria-label" with value "Mark Unread"
