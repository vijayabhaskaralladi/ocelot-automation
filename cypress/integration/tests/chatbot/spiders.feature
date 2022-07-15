Feature: Chatbot Spider

  Scenario: Smoke Test for Spider page under Chatbot
    Given Login as "defaultUser"
    And Open chatbot "chatbotForAutomation"
    When Open "Chatbot->Spiders" menu item
    Then Verify that selector "chatbot.spider.spiderTable" contains more than "1" elements
    When Click on "chatbot.spider.viewFirstSpiderButton"
    Then Tag "h1" with text "Content" should "exist"
    And Tag "#notistack-snackbar" with text "There was an error retrieving data from the server." should "not.exist"
