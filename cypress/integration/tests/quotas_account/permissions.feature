Feature: Permission Manager

  Scenario: TMD-79: Limited users can't open Permission Manager
  These users shouldn't see "Quotas & Account" menu item
    Given Login using random user from the list
      | chatbotLimited    |
      | chatbotStandard   |
      | campaignsLimited  |
      | campaignsStandard |
      | liveChatLimited   |
      | liveChatStandard  |
    And Open chatbot "chatbotForAutomation"
    When Open "" menu item
    Then Tag "span.MuiButton-label" with text "Quotas & Account" should "not.exist"

  Scenario: TMD-79: Admin users without Permission Manager role can't open Permission Manager
  These users can see "Quotas & Account" menu item but it shouldn't contain "Permissions" sub item
    Given Login using random user from the list
      | chatbotAdmin   |
      | campaignsAdmin |
      | liveChatAdmin  |
    And Open chatbot "chatbotForAutomation"
    When Open "Quotas & Account" menu item
    Then Tag "span.MuiButton-label" with text "Permissions" should "not.exist"

  Scenario: TMD-80: Verify that Permission Manager shows list of users(chatbot/livechat/campaigns)
  This test verifies that permission manager gets user records
  chatbot/live chat/campaigns tabs contain 5+ users
    Given Login as "defaultUser"
    And Open chatbot "chatbotForAutomation"
    When Open "Quotas & Account->Permissions" menu item
    Then Verify that selector "quotasAccount.permissions.userRows" contains more than "5" elements

    When Click on "quotasAccount.permissions.liveChatTab"
    Then Verify that selector "quotasAccount.permissions.userRows" contains more than "5" elements

    When Click on "quotasAccount.permissions.campaignsTab"
    Then Verify that selector "quotasAccount.permissions.userRows" contains more than "5" elements

  Scenario: TMD-80: Check that permission manager shows correct data
  Test opens BookstoreCanViewOtherOffices user(chatbot tab) and verifies the output
    Given Login as "defaultUser"
    And Open chatbot "chatbotForAutomation"
    And Open "Quotas & Account->Permissions" menu item

    When Type "BookstoreCanViewOtherOffices{enter}" in "quotasAccount.permissions.searchInput"
    And Click on tag "span" which contains text "BookstoreCanViewOtherOffices"

    Then Verify that element "quotasAccount.permissions.roleValue" contains the following text "Standard"
    And Verify that element "quotasAccount.permissions.viewOtherOfficesSwitch" has attribute "value" with value "true"
    And Verify that checkbox "quotasAccount.permissions.office1Checkbox" is "unchecked"
    And Verify that checkbox "quotasAccount.permissions.office2Checkbox" is "checked"
    And Verify that checkbox "quotasAccount.permissions.office3Checkbox" is "unchecked"
