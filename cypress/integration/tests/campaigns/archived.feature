Feature: Permissions - active campaigns

  Scenario: Viewing Archived Campaigns
    Given Login using random user from the list
      | campaignsLimited          |
      | campaignsStandard         |
      | campaignsAdmin            |
      | viewOtherOfficesCampaigns |
    And Open chatbot "chatbotForAutomation"
    When Open "Campaigns->Archived" menu item
    Then Verify that browser tab title contains "Archived"
