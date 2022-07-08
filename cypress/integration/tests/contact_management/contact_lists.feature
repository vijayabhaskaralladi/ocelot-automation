Feature: Permissions - contact lists

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

  Scenario: TMD-14: Exporting contacts
    Given Login using random user from the list
      | campaignsStandard         |
      | campaignsAdmin            |
      | viewOtherOfficesCampaigns |
    When Open "Contact Management->Contacts" menu item
    And Intercept "${MESSAGE_API_DOMAIN}student-profiles/exported*" as "downloadRequest"
    And Add reload event listener
    And Click on "contactManagement.contacts.downloadContacts"
    # generating csv file takes some time and we need to wait for it
    And Wait for "downloadRequest" network call
    Then Verify that download folder contains "student-profiles.csv"

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

    #ToDo: create step 'Create contact list from file ...'
    When Click on "contactManagement.contactLists.addContactListButton"
    And Attach file "contact_list.csv" to "contactManagement.contactLists.csvInput" input
    And Click on "contactManagement.contactLists.nextButton"

    And Click on "contactManagement.contactLists.header1Input"
    And Click on tag "span" which contains text "First Name"
    And Click on "contactManagement.contactLists.header2Input"
    And Click on tag "span" which contains text "Last Name"
    And Click on "contactManagement.contactLists.header3Input"
    And Click on tag "span" which contains text "Email Address"
    And Click on "contactManagement.contactLists.header4Input"
    And Click on tag "span" which contains text "Phone Number"
    And Click on "contactManagement.contactLists.nextButton"

    And Create random number and save it as "randomNumber"
    And Type "ContactList${randomNumber}" in "contactManagement.contactLists.nameInput"
    And Type "automation{enter}" in "contactManagement.contactLists.tagsInput"
    And Click on "contactManagement.contactLists.createContactListButton"

    Then Tag "p" with text "Argument Validation Error" should "not.exist"
    And Click on "contactManagement.contactLists.finishButton"

  Scenario: TMD-20: Editing Contact Lists
    Given Login using random user from the list
      | campaignsStandard |
      | campaignsAdmin    |
    And Open chatbot "chatbotForAutomation"
    And Open "Contact Management->Contact Lists" menu item

    When Click on "contactManagement.contactLists.actionsDropdownFirstRow"
    And Click on tag "li[role='menuitem']" which contains text "Edit"

    Then Tag "h6" with text "Update Contact List" should "exist"

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
    And Click on tag ".MuiDialogActions-root>button>span" which contains text "Clone"

    Then Type "ClonedList${randomNumber}{enter}" in "contactManagement.contactLists.searchInput"
    And Element "td>p" should "exist"

  Scenario: TMD-22: Verify that user Campaigns Admin can Delete Contact Lists
  This test requires at least 1 contact list
    Given Login as "campaignsAdmin"
    And Open chatbot "chatbotForAutomation"
    And Open "Contact Management->Contact Lists" menu item
    And Retrieve text from "contactManagement.contactLists.firstCampaignName" and save as "campaignName"

    When Click on "contactManagement.contactLists.actionsDropdownFirstRow"
    And Click on tag "li[role='menuitem']" which contains text "Delete"
    And Click on tag "span" which contains text "Ok"

    And Type "${campaignName}{enter}" in "contactManagement.contactLists.searchInput"
    Then Element "td>p" should "not.exist"

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
    And Open "" menu item
    Then Tag "span.MuiButton-label" with text "Contact Management" should "not.exist"

  @need_to_fix
  Scenario Outline: Verify that <user_name> can change the columns in Contact List
    Given Login as "<user_name>"
    And Open chatbot "chatbotForAutomation"
    When Open "Contact Management->Contact Lists" menu item
    Then Type "ContactList" in "contactManagement.contactLists.searchInput"
    And Wait for element "contactManagement.contactLists.tableRows"
    When Click on "contactManagement.contactLists.actionsDropdownFirstRow"
    And Click on "contactManagement.contactLists.EditElement"
    And Wait for element "contactManagement.contactLists.AdvancedModeButton"
    And Click on "contactManagement.contactLists.AdvancedModeButton"
    And Type "Adding" in "contactManagement.contactLists.AddElement"
    And Click on "contactManagement.contactLists.FieldType"
    And Click on "contactManagement.contactLists.FieldText"
    And Click on "contactManagement.contactLists.Column2"
    And Click on "contactManagement.contactLists.NoneSelection"
    And Click on "contactManagement.contactLists.AddField"
    And Click on last element "contactManagement.contactLists.LastElement"
    And Click on "contactManagement.contactLists.AddColumn2"
    And Click on "contactManagement.contactLists.NextElement"
    And Click on "contactManagement.contactLists.UpdateContactList"
    And Click on "contactManagement.contactLists.finishButton"
    And Click on "contactManagement.contactLists.ViewButton"
    And Tag "span" with text "Adding" should "exist"
    Examples:
      | user_name         |
      | campaignsStandard |

  Scenario Outline:TMD-85: Verify that <user_name> can change the columns in Contact List
    Given Login as "<user_name>"
    And Open chatbot "chatbotForAutomation"
    When Open "Contact Management->Contact Lists" menu item
    And Wait for element "contactManagement.contactLists.ContactManagementTag"
    Then Type "qwer" in "contactManagement.contactLists.searchInput"
    And Wait for element "contactManagement.contactLists.singleElement"
    And Click on "contactManagement.contactLists.viewFirstRow"
    And Wait for element "contactManagement.contactLists.EditContact"
    And Click on "contactManagement.contactLists.EditContact"
    And Type "FirstName" in "contactManagement.contactLists.EditFirstName"
    And Click on "contactManagement.contactLists.UpdateButton"
    And Tag "p" with text "FirstName" should "exist"
    Examples:
      | user_name         |
      | campaignsStandard |

  @need_to_fix
  Scenario: TMD-27: Updating contact list
  Test requires at least 1 existing contact list
    Given Login as "campaignsAdmin"
    When Open "Contact Management->Contact Lists" menu item
    And Wait for element "contactManagement.contactLists.searchInput"
    And Click on "contactManagement.contactLists.viewFirstRow"
    And Wait for element "contactManagement.contactLists.edit_contact"
    And Click on "contactManagement.contactLists.edit_contact"
    And Type "sample_edit@yopmail.com" in "contactManagement.contactLists.email_text_box"
    And Click on "contactManagement.contactLists.update_button"
    And Wait for element "contactManagement.contactLists.success_banner"
    Then Tag "div" with text "Contact updated" should "exist"
