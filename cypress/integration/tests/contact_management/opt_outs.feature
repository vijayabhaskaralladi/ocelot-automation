Feature: Permissions - opt-outs

  Scenario: Verify that user Campaigns Limited can't Add new Opt-outs
    Given Login as "campaignsLimited"
    And Open chatbot "chatbotForAutomation"

    When Open "Contact Management->Opt-outs" menu item
    And Wait "2000"
    Then Element "contactManagement.optOuts.addContactButton" should "not.exist"

  Scenario: Verify that user Campaigns StandardLimited can Add Opt-outs and can't delete them
    Given Login as "campaignsStandard"
    And Open chatbot "chatbotForAutomation"
    And Open "Contact Management->Opt-outs" menu item

    When Click on "contactManagement.optOuts.addContactButton"
    And Create random number and save it as "randomNumber"
    And Type "myemail_${randomNumber}@domain.com" in "contactManagement.optOuts.emailInput"
    And Click on "contactManagement.optOuts.saveOptOut"

    Then Type "myemail_${randomNumber}@domain.com{enter}" in "contactManagement.optOuts.searchInput"
    And Wait "1000"
    And Tag "p" with text "myemail_" should "exist"
    And Element "contactManagement.optOuts.deleteButtons" should "not.exist"

  Scenario: Verify that user Campaigns Admin can Add/Search/Delete Opt-outs
    Given Login as "campaignsAdmin"
    And Open chatbot "chatbotForAutomation"
    And Open "Contact Management->Opt-outs" menu item

    When Click on "contactManagement.optOuts.addContactButton"
    And Create random number and save it as "randomNumber"
    And Type "myemail_${randomNumber}@domain.com" in "contactManagement.optOuts.emailInput"
    And Click on "contactManagement.optOuts.saveOptOut"

    Then Type "myemail_${randomNumber}@domain.com{enter}" in "contactManagement.optOuts.searchInput"
    And Wait "1000"
    And Tag "p" with text "myemail_" should "exist"

    When Click on "contactManagement.optOuts.deleteFirstRowButton"
    And Click on "contactManagement.optOuts.confirmDeleteButton"
    And Wait "1000"

    Then Type "myemail_${randomNumber}@domain.com{enter}" in "contactManagement.optOuts.searchInput"
    And Wait "1000"
    And Tag "p" with text "myemail_" should "not.exist"

  Scenario Outline: TMD-86: Verify that <user_name> can opt-In a opted out contact if the phone number and email for the
  contact are removed from opt out portal.
    Given Login as "<user_name>"
    And Open chatbot "chatbotForAutomation"
    When Open "Contact Management->Contact Lists" menu item
    Then Type "qwert" in "contactManagement.contactLists.searchInput"
    And Wait for element "contactManagement.contactLists.singleElement"
    And Click on "contactManagement.contactLists.viewFirstRow"
    And Wait for element "contactManagement.contactLists.EditContact"
    And Optout first contact if opted-In
    And Get the opted out the PhoneNumber and EMail
    And Open "Contact Management->Opt-outs" menu item
    Then Type "${email}" in "contactManagement.optOuts.searchInput"
    And Wait for element "contactManagement.contactLists.singleElement"
    When Click on "contactManagement.optOuts.deleteFirstRowButton"
    And Click on "contactManagement.optOuts.confirmDeleteButton"
    Then Type "${phnNumber}" in "contactManagement.optOuts.searchInput"
    And Wait for element "contactManagement.contactLists.singleElement"
    When Click on "contactManagement.optOuts.deleteFirstRowButton"
    And Click on "contactManagement.optOuts.confirmDeleteButton"
    When Open "Contact Management->Contact Lists" menu item
    Then Type "qwert" in "contactManagement.contactLists.searchInput"
    And Wait for element "contactManagement.contactLists.singleElement"
    And Click on "contactManagement.contactLists.viewFirstRow"
    And Wait for element "contactManagement.contactLists.EditContact"
    And Element "contactManagement.optOuts.optOutButton" should "exist"
    Examples:
      | user_name      |
      | campaignsAdmin |