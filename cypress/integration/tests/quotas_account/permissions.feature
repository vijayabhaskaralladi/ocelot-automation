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
    Then Tag "li>button" with text "Quotas & Account" should "not.exist"

  Scenario: TMD-79: Admin users without Permission Manager role can't open Permission Manager
  These users can see "Quotas & Account" menu item but it shouldn't contain "Permissions" sub item
    Given Login using random user from the list
      | chatbotAdmin   |
      | campaignsAdmin |
      | liveChatAdmin  |
    And Open chatbot "chatbotForAutomation"
    When Open "Quotas & Account" menu item
    Then Tag "li>a" with text "Permissions" should "not.exist"

  Scenario: TMD-80: Verify that Permission Manager shows list of users(chatbot/livechat/texting)
  This test verifies that permission manager gets user records
  chatbot/live chat/texting tabs contain 5+ users
    Given Login as "defaultUser"
    And Open chatbot "chatbotForAutomation"
    When Open "Quotas & Account->Permissions" menu item
    Then Verify that selector "quotasAccount.permissions.userRows" contains more than "5" elements

    When Click on "quotasAccount.permissions.liveChatTab"
    Then Verify that selector "quotasAccount.permissions.userRows" contains more than "5" elements

    When Click on "quotasAccount.permissions.textingTab"
    Then Verify that selector "quotasAccount.permissions.userRows" contains more than "5" elements

  Scenario: TMD-80: Check that permission manager shows correct data
  Test opens BookstoreCanViewOtherOffices user(chatbot tab) and verifies the output
    Given Login as "defaultUser"
    And Open chatbot "chatbotForAutomation"
    And Open "Quotas & Account->Permissions" menu item

    When Type "BookstoreCanViewOtherOffices{enter}" in "quotasAccount.permissions.searchInput"
    And Click on tag "span" which contains text "BookstoreCanViewOtherOffices"

    Then Verify that element "quotasAccount.permissions.roleValue" has the following text "Standard"
    And Verify that element "quotasAccount.permissions.viewOtherOfficesSwitch" has attribute "value" with value "true"
    And Verify that checkbox "quotasAccount.permissions.office1Checkbox" is "unchecked"
    And Verify that checkbox "quotasAccount.permissions.office2Checkbox" is "checked"
    And Verify that checkbox "quotasAccount.permissions.office3Checkbox" is "unchecked"

  @do_not_run_on_com
  Scenario: Updating permissions
  This test requires user with name 'LegacyUser'. It updates it's 'chatbot role' and 'view other offices'.
    Given Login as "defaultUser"
    And Open chatbot "chatbotForAutomation"
    And Open "Quotas & Account->Permissions" menu item
    And Choose random value from "Chatbot|Live Chat|Texting" and save it as "Tab"
    And Click on tag "div[role='tablist']>button" which contains text "${Tab}"
    And Choose random value from "Limited|Standard|Admin" and save it as "role"
    And Choose random value from "enabled|disabled" and save it as "viewOtherOfficesSwitch"
    And Choose random value from "enabled|disabled" and save it as "Offices1Switch"
    And Choose random value from "enabled|disabled" and save it as "Offices2Switch"
    And Choose random value from "enabled|disabled" and save it as "Offices3Switch"
    And Wait for element "quotasAccount.permissions.usersList"
    When Type "LegacyUser{enter}" in "quotasAccount.permissions.searchInput"
    Then Wait for tag with text
      | tag     | span       |
      | text    | LegacyUser |
      | timeout | 20000      |
    And Click on tag "span" which contains text "LegacyUser"

    And Click on "#rolesField"
    And Click on tag "li" which contains text "${role}"
    And Set switch for slider "quotasAccount.permissions.viewOtherOfficesSwitch" to "${viewOtherOfficesSwitch}"
    And Set switch for checkbox "quotasAccount.permissions.office1Checkbox" to "${Offices1Switch}"
    And Set switch for checkbox "quotasAccount.permissions.office2Checkbox" to "${Offices2Switch}"
    And Click on tag "button" which contains text "Save"

    Then Check that notification message "Permissions saved successfully" appeared

  @do_not_run_on_com
  Scenario: TMD-80: Verify that filtering Permission Manager data filters list of users(chatbot/livechat/texting)
    Given Login as "defaultUser"
    And Open chatbot "chatbotForAutomation"
    And Open "Quotas & Account->Permissions" menu item
    And Choose random value from "Chatbot|Live Chat|Texting" and save it as "Tab"
    And Choose random value from "Limited|Standard|Administrator" and save it as "role"

    When Click on tag "div[role='tablist']>button" which contains text "${Tab}"
    And Click on "quotasAccount.permissions.filterRecord"
    And Click on "quotasAccount.permissions.roleFilter"
    And Wait for element "quotasAccount.permissions.usersList"
    And Click on tag "li[role='option']" which contains text "${role}"
    Then Wait for tag with text
      | tag     | span    |
      | text    | ${role} |
      | timeout | 10000   |

    And Wait for tag with text
      | tag     | div.MuiTypography-root |
      | text    | ${role}                |
      | timeout | 10000                  |
    Then Wait "2000"

    And Save number of elements with tag "div.MuiTypography-root>div.MuiChip-sizeSmall>span.MuiChip-label" and "${role}" text as "numberOfLabels"
    And Save number of elements with selector "div.MuiListItemText-multiline>span.MuiTypography-root" as "totalNumberOfUsers"
    Then Check that difference between "numberOfLabels" and "totalNumberOfUsers" is "0"