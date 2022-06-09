Feature: Permissions - chatbot variables

  Scenario Outline: Verify that user can see chatbot variables for his library - <library_name>
  User should see variables for his office(library) and variables which are visible for everyone. Also user shouldn't see
  variables from other libraries
    Given Login as "<user>"
    And Open chatbot "chatbotForAutomation"

    When Open "Chatbot->Variables" menu item
    And Click on tag "p" which contains text "General"
    Then Tag "p" with text "Me" should "exist"
    And Tag "td>div" with text "automation chatbot" should "exist"

    When Click on tag "span" which contains text "Custom"
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
    And Click on tag "p" which contains text "General"
    Then Tag "p" with text "Me" should "exist"
    And Tag "td>div" with text "automation chatbot" should "exist"

    When Click on tag "span" which contains text "Custom"
    Then Click on tag "p" which contains text "Financial Aid"
    And Tag "p" with text "Test Variable (Financial Aid)" should "exist"
    And Tag "div" with text "randomtext_financial_aid" should "exist"
    And Tag "p" with text "Bookstore" should "not.exist"
