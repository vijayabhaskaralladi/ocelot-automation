Feature: Look & Feel

  Scenario: Verify contents of Default/No office and Office tabs
    Given Login as "defaultUser"
    And Open chatbot "chatbotForAutomation"
    When Open "Chatbot->Look & Feel" menu item
    Then Tag "h1" with text "Look & Feel" should "exist"
    And Tag "div" with text "Bottom-Right" should "exist"
    And Tag "div" with text "Simple" should "exist"
    And Tag "div" with text "May I help you?" should "exist"
    And Tag "div" with text "Hi there! I’m a chatbot here to answer your questions. What would you like to know?" should "exist"
    And Click on "button.MuiTab-textColorInherit:not([class*='Mui-selected'])"
    And Tag "p" with text "Office 1" should "exist"
    And Tag "p" with text "Office 2" should "exist"
    And Tag "p" with text "Office 3" should "exist"

  Scenario: Changing welcome message
    Given Login as "defaultUser"
    And Open chatbot "chatbotForAutomation"
    And Open "Chatbot->Look & Feel" menu item
    And Create random number and save it as "id"

    When Click on tag "span" which contains text "Edit"
    And Type "Welcome message: #${id}. Chatbot name: !me" in "chatbot.lookAndFeel.welcomeMessageInput"
    And Click on tag "span" which contains text "Save"

    Then Tag "#notistack-snackbar" with text "Updated" should "exist"
    And API: Select "chatbotForAutomation" chatbot
    And API: Check that chatbot welcome message is "<p>Welcome message: #${id}. Chatbot name: automation chatbot</p>"

