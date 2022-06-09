Feature: Permissions - active campaigns

  Scenario: View Active Campaigns page
    Given Login using random user from the list
      | campaignsLimited          |
      | campaignsStandard         |
      | campaignsAdmin            |
      | viewOtherOfficesCampaigns |
    And Open chatbot "chatbotForAutomation"
    When Open "Campaigns->Active" menu item
    Then Verify that browser tab title contains "Active"

  Scenario: Verify that user can View Inbox page
    Given Login using random user from the list
      | campaignsLimited  |
      | campaignsStandard |
      | campaignsAdmin    |
    And Open chatbot "chatbotForAutomation"
    When Open "Inbox" menu item
    Then Tag "div.MuiBox-root" with text "Needs Attention" should "exist"

  # active campaigns page contains drafts and 'active' campaigns
  # these 2 types have different general tab page, test should handle this
  @need_to_fix
  Scenario: Verify that user can View General Settings in a campaign
    Given Login using random user from the list
      | campaignsLimited  |
      | campaignsStandard |
      | campaignsAdmin    |
    And Open chatbot "chatbotForAutomation"
    When Open "Campaigns->Active" menu item
    And Click on "campaigns.active.viewFirstRow"
    And Click on "campaigns.active.generalTab"
    And Retrieve text from "campaigns.active.campaignName" and save as "CampaignName"
    And Verify that "CampaignName" length is greater than "2"
