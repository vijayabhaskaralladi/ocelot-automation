Feature: Quotas and Accounts

  Scenario: TMD-78: Verify number of Licensed Agents is greater than zero
    Given Login using random user from the list
      | chatbotAdmin   |
      | liveChatAdmin  |
      | campaignsAdmin |
    And Open chatbot "chatbotForAutomation"
    When Open "Quotas & Account->Contract Limits" menu item
    Then Verify that element "quotasAccount.contractLimits.licensedAgentsNumber" contains positive number
