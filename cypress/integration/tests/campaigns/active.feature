Feature: Permissions - active campaigns

  Scenario: View Active Campaigns page
    Given Login using random user from the list
      | campaignsLimited          |
      | campaignsStandard         |
      | campaignsAdmin            |
      | viewOtherOfficesCampaigns |
    And Open chatbot "chatbotForAutomation"
    When Open "Texting->Active Campaigns" menu item
    Then Verify that browser tab title contains "Active"

  Scenario: Verify that user can View Inbox page
    Given Login using random user from the list
      | campaignsLimited  |
      | campaignsStandard |
      | campaignsAdmin    |
    And Open chatbot "chatbotForAutomation"
    When Open "Inbox" menu item
    Then Tag "div.MuiBox-root" with text "Needs Attention" should "exist"

  Scenario: Verify that user can View General Settings in a campaign
    Given Login using random user from the list
      | campaignsLimited  |
      | campaignsStandard |
      | campaignsAdmin    |
    And Open chatbot "chatbotForAutomation"
    When Open "Texting->Active Campaigns" menu item
    And URL should include "campaigns/active"
    And Add "?status=Active" to the current URL
    And Click on "texting.activeCampaigns.viewFirstRow"
    And Click on "texting.activeCampaigns.generalTab"
    And Retrieve text from "texting.activeCampaigns.campaignName" and save as "CampaignName"
    And Verify that "CampaignName" length is greater than "3"
