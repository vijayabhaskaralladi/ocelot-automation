Feature: Look & Feel

  Scenario: Verify contents of Default/No office and Office tabs
    Given Login as "defaultUser"
    And Open chatbot "chatbotForAutomation"
    When Open "Chatbot->Look & Feel" menu item
    Then Tag "h1" with text "Look & Feel" should "exist"
    And Tag "div" with text "Bottom-Right" should "exist"
    And Tag "div" with text "Simple" should "exist"
    And Tag "div" with text "May I help you?" should "exist"
    And Tag ".LookAndFeelSettingsForm-markdownPreview" with text "Welcome message: #" should "exist"
    And Click on "button[role='tab']:not([aria-selected='true'])"
    And Tag "p" with text "Office 1" should "exist"
    And Tag "p" with text "Office 2" should "exist"
    And Tag "p" with text "Office 3" should "exist"

  Scenario: Changing welcome message
    Given Login as "defaultUser"
    And Open chatbot "chatbotForAutomation"
    And Open "Chatbot->Look & Feel" menu item
    And Create random number and save it as "id"

    When Click on tag "button" which contains text "Edit"
    And Type "Welcome message: #${id}. Chatbot name: !me" in "chatbot.lookAndFeel.welcomeMessageInput"
    And Click on tag "button" which contains text "Save"
    Then Check that notification message "Updated" appeared
    And Wait "10000"

    And API: Select "chatbotForAutomation" chatbot
    And API: Check that chatbot welcome message is "Welcome message: #${id}. Chatbot name: automation chatbot"