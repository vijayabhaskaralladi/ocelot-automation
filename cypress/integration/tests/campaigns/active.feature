Feature: Permissions - active campaigns

  Scenario: Update Campaign
    Given Login using random user from the list
      | campaignsStandard         |
      | campaignsAdmin            |
      | viewOtherOfficesCampaigns |
    And Open chatbot "chatbotForAutomation"
    And Open "Texting->Active Campaigns" menu item
    And URL should include "campaigns"
    And Add "?status=Draft" to the current URL
    And Click on "common.texting.viewFirstRow"
    And Create random number and save it as "id"
    And Choose random value from "1 Day|2 Day|3 Day|4 Day" and save it as "automaticArchive"
    When Update campaign
      | campaignName     | EditCampaign${id} |
      | message          | Hi${id}           |
      | automaticArchive | 1 day             |

  Scenario: Cloning active campaign
    Given Login using random user from the list
      | campaignsStandard |
      | campaignsAdmin    |
    And Open chatbot "chatbotForAutomation"
    And Open "Texting->Active Campaigns" menu item
    And Create random number and save it as "randomNumber"

    When Click on "common.texting.actions.actionDropdown"
    And Click on "common.texting.actions.cloneButton"
    And Type "ClonedActiveCampaign${randomNumber}" in "texting.activeCampaigns.campaignNameInputDialog"
    And Click on "common.texting.confirmClone"
    And Element "span.MuiSkeleton-pulse" should "not.exist"
    And Intercept "${GRAPHQL_URL}graphql" with "SearchCampaigns" keyword in the response as "searchRequest"
    And Type "ClonedActiveCampaign${randomNumber}" in "texting.activeCampaigns.keywordSearch"
    And Wait for "searchRequest" network call
    Then Tag "tr>td>p" with text "ClonedActiveCampaign${randomNumber}" should "exist"

    When Click on "common.texting.actions.actionDropdown"
    And Click on "common.texting.actions.cloneButton"
    And Type "ClonedActiveCampaign${randomNumber}" in "texting.activeCampaigns.campaignNameInputDialog"
    And Click on "common.texting.confirmClone"
    Then Tag "p" with text "Campaign title must be unique" should "exist"

  Scenario: View Active Campaigns page
    Given Login using random user from the list
      | campaignsLimited          |
      | campaignsStandard         |
      | campaignsAdmin            |
      | viewOtherOfficesCampaigns |
    And Open chatbot "chatbotForAutomation"
    When Open "Texting->Active Campaigns" menu item
    Then Verify that browser tab title contains "Active"
    And Intercept "${GRAPHQL_URL}graphql" with "SearchCampaigns" keyword in the response as "searchRequest"
    And Click on "common.texting.filterResults"
    And Click on "common.texting.statusFilter"
    And Click on "common.texting.draftFilter"
    And Wait for "searchRequest" network call
    Then Verify that element "texting.activeCampaigns.draftFilterName" has the following text "Status: Draft"
    And Verify that selector "texting.activeCampaigns.campaginListTable" contains more than "1" elements

  @low_priority
  Scenario: Verify that user can View Inbox page
    Given Login using random user from the list
      | campaignsLimited  |
      | campaignsStandard |
      | campaignsAdmin    |
    And Open chatbot "chatbotForAutomation"
    When Open "Inbox" menu item
    Then Tag "div.MuiBox-root" with text "Needs Attention" should "exist"

  # usually we don't have active campaigns
  @exclude_from_ci
  Scenario: Verify that user can View General Settings in a campaign
  This test requires at least 1 campaign in active state
    Given Login using random user from the list
      | campaignsLimited  |
      | campaignsStandard |
      | campaignsAdmin    |
    And Open chatbot "chatbotForAutomation"
    When Open "Texting->Active Campaigns" menu item
    And URL should include "campaigns/active"
    And Add "?status=Active" to the current URL
    And Click on "common.texting.viewFirstRow"
    And Click on "texting.activeCampaigns.generalTab"
    And Retrieve text from "texting.activeCampaigns.campaignName" and save as "CampaignName"
    And Verify that "CampaignName" length is greater than "3"

  Scenario: Active campaigns - Exporting contacts
    Given Login using random user from the list
      | campaignsLimited          |
      | campaignsStandard         |
      | campaignsAdmin            |
      | viewOtherOfficesCampaigns |
    And Open chatbot "chatbotForAutomation"
    And Open "Texting->Active Campaigns" menu item

    When Click on "common.texting.viewFirstRow"
    And Click on tag "button" which contains text "Contacts"
    And Retrieve text from "texting.activeCampaigns.firstContactNumber" and save as "PhoneNumber"

    Then Add reload event listener
    And Click on "common.texting.exportResultsToCSV"
    And Verify that download folder contains "contact-list.csv"
    And Verify that file "contact-list.csv" from download folder contains text "${PhoneNumber}"
