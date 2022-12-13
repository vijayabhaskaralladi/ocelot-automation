Feature: Permissions - contact lists

  Scenario: Uploading big contact list
  Test uploads big contact list, removes 1 contact from it and then deletes this contact list
    Given Login as "defaultUser"
    And Open chatbot "chatbotForAutomation"
    And Open "Contact Management->Contact Lists" menu item
    And Create random number and save it as "randomNumber"

    When Click on "contactManagement.contactLists.addContactListButton"
    And Attach file "ContactList-5K.csv" to "contactManagement.contactLists.csvInput" input
    And Click on "contactManagement.contactLists.nextButton"
    And Configure columns for contact list
      | header1 | First Name    |
      | header2 | Last Name     |
      | header3 | Phone Number  |
      | header4 | Email Address |
    And Click on "contactManagement.contactLists.nextButton"

    And Type "BigContactList${randomNumber}" in "contactManagement.contactLists.nameInput"
    And Type "automation{enter}" in "contactManagement.contactLists.tagsInput"
    And Click on "contactManagement.contactLists.createContactListButton"
    And Wait for tag with text
      | tag     | p            |
      | text    | Successfully |
      | timeout | 1000000      |
    Then Tag "p" with text "Argument Validation Error" should "not.exist"
    And Click on "contactManagement.contactLists.finishButton"

    Then Type "BigContactList${randomNumber}" in "contactManagement.contactLists.searchInput"
    And Verify that selector "contactManagement.contactLists.tableRows" contains "1" elements
    And Click on "contactManagement.contactLists.viewFirstContactListButton"
    And Click on "contactManagement.contactLists.deleteFirstContact"
    And Click on tag "button" which contains text "Ok"
    And Check that notification message "Contact removed" appeared

    And Open chatbot home page
    And Open "Contact Management->Contact Lists" menu item
    And Type "BigContactList${randomNumber}{enter}" in "contactManagement.contactLists.searchInput"
    And Verify that selector "contactManagement.contactLists.tableRows" contains "1" elements
    And  Click on "contactManagement.contactLists.actionsDropdownFirstRow"
    And Click on tag "li[role='menuitem']" which contains text "Delete"
    And Click on tag "button" which contains text "Ok"
    Then Check that notification message "Contact list removed" appeared
    And Type "BigContactList${randomNumber}{enter}" in "contactManagement.contactLists.searchInput"
    And Element "td>p" should "not.exist"

  Scenario: Viewing Contact Lists
    Given Login using random user from the list
      | campaignsLimited          |
      | campaignsStandard         |
      | campaignsAdmin            |
      | viewOtherOfficesCampaigns |
    And Open chatbot "chatbotForAutomation"
    When Open "Contact Management->Contact Lists" menu item
    Then Verify that page title is "Contact Lists"
    And Click on "contactManagement.contactLists.viewFirstContactListButton"
    And Tag "span" with text "contact management" should "exist"
    And Tag "span" with text "First Name" should "exist"

  Scenario: TMD-16: Verify that user Campaigns Limited can't Create Contact Lists
  Limited user shouldn't see 'Add Contact List' button
    Given Login as "campaignsLimited"
    And Open chatbot "chatbotForAutomation"

    When Open "Contact Management->Contact Lists" menu item
    # Waiting for rows
    And Element "td>p" should "exist"
    Then Element "contactManagement.contactLists.addContactListButton" should "not.exist"

  Scenario: TMD-17: Verify that user Campaigns Limited can't Delete Contact Lists
  Limited user shouldn't see 'Actions' dropdown
    Given Login as "campaignsLimited"
    And Open chatbot "chatbotForAutomation"
    When Open "Contact Management->Contact Lists" menu item
    Then Element "contactManagement.contactLists.actionsDropdowns" should "not.exist"

  Scenario: TMD-18: Verify that user Campaigns Standard can't Delete Contact Lists
  Standard user sees 'Actions' dropdown without 'Delete' action
    Given Login as "campaignsStandard"
    And Open chatbot "chatbotForAutomation"
    When Open "Contact Management->Contact Lists" menu item
    And Click on "contactManagement.contactLists.actionsDropdownFirstRow"
    Then Tag "li[role='menuitem']" with text "Delete" should "not.exist"

  Scenario: TMD-19: Creating Contact Lists
    Given Login using random user from the list
      | campaignsStandard |
      | campaignsAdmin    |
    And Open chatbot "chatbotForAutomation"
    And Open "Contact Management->Contact Lists" menu item

    When Click on "contactManagement.contactLists.addContactListButton"
    And Attach file "contact_list.csv" to "contactManagement.contactLists.csvInput" input
    And Click on "contactManagement.contactLists.nextButton"
    And Configure columns for contact list
      | header1 | First Name    |
      | header2 | Last Name     |
      | header3 | Email Address |
      | header4 | Phone Number  |
    And Click on "contactManagement.contactLists.nextButton"

    And Create random number and save it as "randomNumber"
    And Type "ContactList${randomNumber}" in "contactManagement.contactLists.nameInput"
    And Type "automation{enter}" in "contactManagement.contactLists.tagsInput"
    And Click on "contactManagement.contactLists.createContactListButton"

    Then Tag "p" with text "Argument Validation Error" should "not.exist"
    And Click on "contactManagement.contactLists.finishButton"

  Scenario: TMD-21: Cloning Contact Lists
    Given Login using random user from the list
      | campaignsStandard |
      | campaignsAdmin    |
    And Open chatbot "chatbotForAutomation"
    And Open "Contact Management->Contact Lists" menu item
    And Create random number and save it as "randomNumber"

    When Click on "contactManagement.contactLists.actionsDropdownFirstRow"
    And Click on tag "li[role='menuitem']" which contains text "Clone"
    And Type "ClonedList${randomNumber}" in "contactManagement.contactLists.cloneNameInput"
    And Click on tag ".MuiDialogActions-root>button" which contains text "Clone"

    Then Type "ClonedList${randomNumber}{enter}" in "contactManagement.contactLists.searchInput"
    And Element "td>p" should "exist"

  Scenario: TMD-27: Updating contact list - changing columns
  Test requires at least 1 existing contact list
    Given Login as "campaignsAdmin"
    When Open "Contact Management->Contact Lists" menu item
    And Click on "contactManagement.contactLists.actionsDropdownFirstRow"
    And Click on tag "li" which contains text "Edit"
    And Verify that element "contactManagement.contactLists.header1Input" has attribute "value" with value "First Name"
    And Verify that element "contactManagement.contactLists.header2Input" has attribute "value" with value "Last Name"
    And Type " " in "contactManagement.contactLists.header1Input"
    And Type " " in "contactManagement.contactLists.header2Input"
    And Type "Last Name" in "contactManagement.contactLists.header1Input"
    And Click on tag "span" which contains text "Last Name"
    And Type "First Name" in "contactManagement.contactLists.header2Input"
    And Click on tag "span" which contains text "First Name"
    And Click on tag "button" which contains text "Next"
    And Click on tag "button" which contains text "Update Contact List"
    And Tag "p" with text "Successfully updated" should "exist"
    And Tag "p" with text "Argument Validation Error" should "not.exist"
    And Click on tag "button" which contains text "Finish"

  Scenario: Editing contact from contact list
    Given Login as "campaignsStandard"
    And Open chatbot "chatbotForAutomation"
    And Open "Contact Management->Contact Lists" menu item
    And Wait for element "contactManagement.contactLists.ContactManagementTag"
    Then Type "qwer" in "contactManagement.contactLists.searchInput"
    And Verify that selector "contactManagement.contactLists.singleElement" contains "1" elements
    And Click on "contactManagement.contactLists.viewFirstRow"
    And Wait for element "contactManagement.contactLists.EditContact"
    And Click on "contactManagement.contactLists.EditContact"
    And Choose random value from "Edward|Alex|John|Bill|Greg" and save it as "firstName"
    And Type "${firstName}" in "contactManagement.contactLists.EditFirstName"
    And Click on "contactManagement.contactLists.UpdateButton"
    And Tag "p" with text "${firstName}" should "exist"

  Scenario: TMD-22: Verify that user Campaigns Admin can Delete Contact Lists
  This test requires at least 1 contact list
    Given Login as "campaignsAdmin"
    And Open chatbot "chatbotForAutomation"
    And Open "Contact Management->Contact Lists" menu item
    And Retrieve text from "contactManagement.contactLists.firstCampaignName" and save as "campaignName"

    When Click on "contactManagement.contactLists.actionsDropdownFirstRow"
    And Click on tag "li[role='menuitem']" which contains text "Delete"
    And Click on tag "button" which contains text "Ok"
    Then Check that notification message "Contact list removed" appeared
    And Type "${campaignName}{enter}" in "contactManagement.contactLists.searchInput"
    And Element "td>p" should "not.exist"

  Scenario: TMD-23: Limited users can't see Contact Lists/Contact Management
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
    And Open "Home" menu item
    Then Tag "button.MuiButton-root" with text "Contact Management" should "not.exist"

  Scenario: Bulk add Contact Lists
    Given Login using random user from the list
      | campaignsStandard |
      | campaignsAdmin    |
    And Open chatbot "chatbotForAutomation"
    And Open "Contact Management->Contact Lists" menu item

    When Click on "contactManagement.contactLists.actionsDropdownFirstRow"
    And Click on tag "li[role='menuitem']" which contains text "Bulk add"
    And Attach file "contact_list_bulk_add.csv" to "contactManagement.contactLists.csvInput" input
    And Click on "contactManagement.contactLists.nextButton"
    And Configure columns for contact list
      | header1 | First Name    |
      | header2 | Last Name     |
      | header3 | Email Address |
      | header4 | Phone Number  |
    Then Click on tag "button" which contains text "Import Contacts"
    And Tag "p" with text "Successfully imported" should "exist"
    And Tag "p" with text "Argument Validation Error" should "not.exist"
    And Click on "contactManagement.contactLists.finishButton"
