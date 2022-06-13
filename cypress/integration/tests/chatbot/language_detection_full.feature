Feature: Chatbot API - language detection

  @ignore
  Scenario: Language detection
  This test sends messages from the input file and verifies language of response.
  Check 'linesWithWrongDetectedLanguage' file after execution.
  P.S. this test makes 1200 requests so don't run on CI
    Given Convert CSV "chatbot_inputs.csv" to JSON and save as "chatbot_inputs.json"
    And API: Select "aimsCommunityCollege" chatbot
    When Verify that chatbot detects language according to "chatbot_inputs.json"
    And Save JSON object stored as "linesWithWrongDetectedLanguage" to "wrong_detected_lang.json"
    Then Verify that "numberOfErrorCodes" should equal "0"
    And Verify that "numberOfMismatches" should equal "0"
