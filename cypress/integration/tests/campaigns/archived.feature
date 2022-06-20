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

  Scenario: Cloning archived campaign
    Given Login using random user from the list
      | campaignsStandard |
      | campaignsAdmin    |
    And Open chatbot "chatbotForAutomation"
    When Open "Campaigns->Archived" menu item
    And Click on "campaigns.archived.firstRowDropdown"
    Then Click on "campaigns.archived.cloneButton"
    And Create random number and save it as "randomNumber"
    And Type "ClonedCampaign${randomNumber}" in "campaigns.archived.campaignNameInputDialog"
    And Click on "campaigns.archived.confirmClone"
    Then Open "Active" menu item
    And Intercept "${GRAPHQL_URL}graphql" with "SearchCampaigns" keyword in the response as "searchRequest"
    And Type "ClonedCampaign${randomNumber}" in "campaigns.active.keywordSearch"
    And Wait for "searchRequest" network call
    And Tag "tr>td>p" with text "ClonedCampaign${randomNumber}" should "exist"
