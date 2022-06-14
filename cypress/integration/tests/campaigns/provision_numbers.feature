Feature: Campaigns - provision numbers

  Scenario: Viewing provision numbers
    Given Login using random user from the list
      | campaignsStandard |
      | campaignsAdmin    |
    And Open chatbot "chatbotForAutomation"
    When Open "Campaigns->Phone Numbers" menu item
    And Verify that element "campaigns.phoneNumbers.phoneNumberFromFirstRow" has phone number
