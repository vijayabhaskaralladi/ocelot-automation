Feature: Test My Bot

  Scenario: Verify Transcript from Test my bot
  Test creates conversation using 'Test My Bot' button and downloads transcript
    Given Login as "defaultUser"
    And Open chatbot "chatbotForAutomation"
    And Create random number and save it as "id"
    And Intercept "POST: ${MESSAGE_API_DOMAIN}api/message" as "messageResponse"

    When Click on "chatbot.testMyBot.buttonTestMyBot"
    And Type "Hi. Random message ${id}{Enter}" in "chatbot.testMyBot.inputAskQuestion"
    And Wait for "messageResponse" network call
    And Type "What is FAFSA?{Enter}" in "chatbot.testMyBot.inputAskQuestion"
    And Wait for "messageResponse" network call
    Then Verify that response "messageResponse" has status code "200"
    And Tag "div" with text "Hi. Random message ${id}" should "exist"
    And Tag "div" with text "What is FAFSA?" should "exist"

    When Click on "chatbot.testMyBot.openMenu"
    And Click on tag "li" which contains text "Download transcript"
    Then Verify that download folder contains "transcript-automation"
    And Get full file name with prefix "transcript-automation" in download folder and save it as "transcriptDownloadFile"
    And Verify that file "${transcriptDownloadFile}" from download folder contains text "Hi. Random message ${id}"
    And Verify that file "${transcriptDownloadFile}" from download folder contains text "What is FAFSA?"