Feature: Language detection

  Background:
    Given API: Select "chatbotForAutomation" chatbot

  @do_not_run_on_com
  Scenario Outline: <test_id>: Verify that chatbot autodetects language - <language>
  Chatbot should be configured to support Spanish, Vietnamese, Chinese and English languages
    When API: Send first message "<message>" and save response as "response"
    Then Verify that response "response" has status code "200"
    And Verify that response "response" has field "body.language" equal to "<expected_language_field>"
    Examples:
      | test_id | language   | message        | expected_language_field |
      | TMD-1   | Spanish    | Buenos días    | es                      |
      | TMD-2   | Vietnamese | chào buổi sáng | vi                      |
      | TMD-3   | Chinese    | 早上好            | zh-hans                 |
      | TMD-8   | English    | Good morning   | en                      |

  @do_not_run_on_com
  Scenario Outline: <test_id>: Verify that chatbot doesn't detect not added language - <language>
    When API: Send first message "<message>" and save response as "response"
    Then Verify that response "response" has status code "200"
    And Verify that response "response" has field "body.language" equal to "en"
    Examples:
      | test_id | language | message |
      | TMD-5   | French   | Bonjour |

  @do_not_run_on_com
  Scenario Outline: <test_id>: Verify that chatbot response when language field set to - <language>
    When API: Set language "<language_code>" and send message "<message>" and save response as "response"
    Then Verify that response "response" has status code "200"
    And Verify that response "response" has field "body.language" equal to "<language_code>"
    And Verify that bot response "response" contains "<expected_response>" message "<language_code>"
    Examples:
      | test_id | language   | language_code | message        | expected_response |
      | TMD-9   | Spanish    | es            | Buenos días    | Hola              |
      | TMD-10  | Vietnamese | vi            | chào buổi sáng | Chào bạn.         |
      | TMD-11  | Chinese    | zh-hans       | 早上好            | 你好                |
