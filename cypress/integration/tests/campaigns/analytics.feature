Feature: Permissions - campaigns analytics

  Scenario: Viewing Campaigns Analytics
    Given Login using random user from the list
      | campaignsLimited          |
      | campaignsStandard         |
      | campaignsAdmin            |
      | viewOtherOfficesCampaigns |
    And Open chatbot "chatbotForAutomation"
    When Open "Campaigns->Analytics" menu item
    And Wait for element "campaigns.analytics.contactResponsesPerHourChart"
    Then Verify that element "campaigns.analytics.contactsMessaged" contains positive number
    And Verify that element "campaigns.analytics.contactsResponded" contains positive number

  Scenario: Limited users can't view Campaigns item in the menu
    Given Login using random user from the list
      | viewOtherOfficesLiveChat |
      | viewOtherOfficesChatbot  |
      | liveChatLimited          |
      | liveChatStandard         |
      | liveChatAdmin            |
      | chatbotLimited           |
      | chatbotStandard          |
      | chatbotAdmin             |
    And Open chatbot "chatbotForAutomation"
    And Open "" menu item
    Then Tag "span.MuiButton-label" with text "Campaigns" should "not.exist"
