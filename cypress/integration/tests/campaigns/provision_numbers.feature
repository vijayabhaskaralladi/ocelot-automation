Feature: Campaigns - provision numbers

  Scenario: Viewing provision numbers
    Given Login using random user from the list
      | campaignsStandard |
      | campaignsAdmin    |
    And Open chatbot "chatbotForAutomation"
    When Open "Texting->Phone Numbers" menu item
    And Verify that element "texting.phoneNumbers.phoneNumberFromFirstRow" has phone number

  Scenario: Exporting list of provision numbers
    Given Login using random user from the list
      | viewOtherOfficesCampaigns |
      | campaignsStandard         |
      | campaignsAdmin            |
    And Open chatbot "chatbotForAutomation"
    And Open "Texting->Phone Numbers" menu item
    When Intercept "${MESSAGE_API_DOMAIN}phone-numbers/exported*" as "downloadRequest"
    And Add reload event listener
    And  Click on "texting.phoneNumbers.exportResults"
    And Wait for "downloadRequest" network call
    Then Verify that download folder contains "phone-numbers.csv"
