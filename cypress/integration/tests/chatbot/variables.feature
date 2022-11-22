Feature: Permissions - chatbot variables

  Scenario Outline: User should see variables for his library - <library_name>
  User should see variables for his office(library) and variables which are visible for everyone. Also user shouldn't see
  variables from other libraries
    Given Login as "<user>"
    And Open chatbot "chatbotForAutomation"

    When Open "Chatbot->Variables" menu item
    Then Verify that element "chatbot.variables.requiredNumber" contains positive number
    And Verify that element "chatbot.variables.optionalNumber" contains positive number

    When Click on tag "p" which contains text "General"
    Then Tag "p" with text "Me" should "exist"
    And Tag "td>div" with text "automation chatbot" should "exist"

    When Click on tag "button" which contains text "Custom"
    Then Click on tag "p" which contains text "<library_name>"
    And Tag "p" with text "<variable_name>" should "exist"
    And Tag "div" with text "<variable_value>" should "exist"
    And Tag "p" with text "<library_name_which_shouldnt_be_visible>" should "not.exist"
    Examples:
      | library_name  | user                               | variable_name                 | variable_value           | library_name_which_shouldnt_be_visible |
      | Financial Aid | chatbotStandard-FinancialAidOffice | Test Variable (Financial Aid) | randomtext_financial_aid | Bookstore                              |
      | Bookstore     | chatbotStandard-BookstoreOffice    | Test Variable (Bookstore)     | randomtext_bookstore     | Financial Aid                          |

  Scenario: Verify that user from Athletics office can see Custom variable from Financial Aid office(same libraries)
  User should be able to see custom variables from other offices if they have the same libraries
    Given Login as "chatbotStandard-AthleticsOffice"
    And Open chatbot "chatbotForAutomation"

    When Open "Chatbot->Variables" menu item
    Then Verify that element "chatbot.variables.requiredNumber" contains positive number
    And Verify that element "chatbot.variables.optionalNumber" contains positive number

    When Click on tag "p" which contains text "General"
    Then Tag "p" with text "Me" should "exist"
    And Tag "td>div" with text "automation chatbot" should "exist"

    When Click on tag "button" which contains text "Custom"
    Then Click on tag "p" which contains text "Financial Aid"
    And Tag "p" with text "Test Variable (Financial Aid)" should "exist"
    And Tag "div" with text "randomtext_financial_aid" should "exist"
    And Tag "p" with text "Bookstore" should "not.exist"

  Scenario: Creating and deleting variables
    Given Login as "defaultUser"
    And Open chatbot "chatbotForAutomation"
    And Open "Chatbot->Variables" menu item
    And Create random number and save it as "id"
    And Choose random value from "Number|Text|Rich Text|Link|Dropdown|Email Address|URL" and save it as "variableType"

    When Create chatbot variable
      | variableName  | automationVariable${id}                                   |
      | placeHolder   | autovar${id}                                              |
      | type          | ${variableType}                                           |
      | numberValue   | 32                                                        |
      | textValue     | value for Text variable. link for more https://google.com |
      | emailValue    | automationsupport@ocelot.com                              |
      | richTextValue | value for Text variable. link for more https://google.com |
      | linkText      | New variable modal HomePage                               |
      | linkURL       | https://ocelot.com                                        |
      | dropDownValue | Texting                                                   |
    Then Check that notification message "Variable saved!" appeared

    When Click on "chatbot.variables.customTab"
    And Click on "chatbot.variables.expandList"
    And Delete variable by name "automationVariable${id}"
    Then Tag "#notistack-snackbar" with text "Variable deleted!" should "exist"

  Scenario: Editing variables
    Given Login as "defaultUser"
    And Create random number and save it as "id"
    And Open chatbot "chatbotForAutomation"
    And Open "Chatbot->Variables" menu item
    And Click on "chatbot.variables.customTab"
    And Click on "chatbot.variables.expandList"

    When Set value "NewValue ${id}" to variable "variable_for_editing"
    Then Check that notification message "Variable saved!" appeared
    And Tag "td>div" with text "NewValue ${id}" should "exist"
