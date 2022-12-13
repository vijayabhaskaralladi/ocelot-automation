Feature: Permissions - archived campaigns

  Scenario: Viewing Archived Campaigns
    Given Login using random user from the list
      | campaignsLimited          |
      | campaignsStandard         |
      | campaignsAdmin            |
      | viewOtherOfficesCampaigns |
    And Open chatbot "chatbotForAutomation"
    When Open "Texting->Archived" menu item
    Then Verify that browser tab title contains "Archived"
    And Verify that selector "texting.archived.archivedRowCount" contains more than "1" elements

    When Click on "common.texting.viewFirstRow"
    Then Click on tag "button" which contains text "General"
    And Tag "h2" with text "General Settings" should "exist"
    And Tag "div" with text "Bot|Operator" should "exist"
    When Click on tag "button" which contains text "Contacts"
    Then Verify that selector "texting.archived.contactsRowCount" contains "1" elements
    When Click on tag "button" which contains text "Analytics"
    And Verify that element "texting.archived.contactsMessaged" contains positive number
    And Verify that element "texting.archived.contactsResponded" contains positive number

  Scenario: Cloning archived campaign
    Given Login using random user from the list
      | campaignsStandard |
      | campaignsAdmin    |
    And Open chatbot "chatbotForAutomation"
    When Open "Texting->Archived" menu item
    And Click on "common.texting.actions.actionDropdown"
    Then Click on "common.texting.actions.cloneButton"
    And Create random number and save it as "randomNumber"
    And Type "ClonedCampaign${randomNumber}" in "texting.archived.campaignNameInputDialog"
    And Click on "common.texting.confirmClone"

    Then Intercept "${GRAPHQL_URL}graphql" with "getLiveChatWhosOnlineStatistics" keyword in the response as "whosOnlineRequest"
    And Open "Active" menu item
    And Tag "span" with text "Draft|Active" should "exist"
    And Intercept "${GRAPHQL_URL}graphql" with "SearchCampaigns" keyword in the response as "searchRequest"
    And Type "ClonedCampaign${randomNumber}" in "texting.activeCampaigns.keywordSearch"
    And Wait for "searchRequest" network call
    And Tag "tr>td>p" with text "ClonedCampaign${randomNumber}" should "exist"
