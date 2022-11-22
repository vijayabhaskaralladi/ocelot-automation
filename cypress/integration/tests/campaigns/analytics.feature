Feature: Permissions - campaigns analytics

  Scenario: Viewing and Exporting Campaigns Analytics
    Given Login using random user from the list
      | campaignsLimited          |
      | campaignsStandard         |
      | campaignsAdmin            |
      | viewOtherOfficesCampaigns |
    And Open chatbot "chatbotForAutomation"
    When Open "Texting->Campaign Analytics" menu item
    And Wait for element "texting.campaignAnalytics.contactResponsesPerHourChart"
    Then Verify that element "texting.campaignAnalytics.contactsMessaged" contains positive number
    And Verify that element "texting.campaignAnalytics.contactsResponded" contains positive number

    When Add reload event listener
    And Click on "texting.campaignAnalytics.exportAnalytics"
    Then Verify that download folder contains "campaign-analytics.csv"
    And Verify that file "campaign-analytics.csv" from download folder contains text "Campaign Name"

  Scenario: Limited users can't view Texting item in the menu
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
    Then Tag "button.MuiButton-label" with text "Texting" should "not.exist"
