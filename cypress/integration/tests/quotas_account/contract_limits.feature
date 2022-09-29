Feature: Quotas and Accounts

  Scenario: TMD-78: Verify number of Licensed Agents is greater than zero
    Given Login using random user from the list
      | chatbotAdmin   |
      | liveChatAdmin  |
      | campaignsAdmin |
    And Open chatbot "chatbotForAutomation"
    When Open "Quotas & Account->Contract Limits" menu item
    Then Verify that element "quotasAccount.contractLimits.licensedAgentsNumber" contains positive number
    And Verify that element "quotasAccount.contractLimits.textingActiveNumber" contains positive number
    And Verify that element "quotasAccount.contractLimits.textingUniqueContactsNumber" contains positive number
    Then Tag "td" with text "MyCampus, Office 1" should "exist"
    Then Tag "td" with text "MyCampus, Office 2" should "exist"
    Then Tag "td" with text "MyCampus, Office 3" should "exist"
    And  Scroll to "quotasAccount.contractLimits.myCampusOffice1ExpandButton" element
    And Click on "quotasAccount.contractLimits.myCampusOffice1ExpandButton"
    Then Tag "td" with text "Automation, ViewOtherOfficesLiveChat" should "exist"