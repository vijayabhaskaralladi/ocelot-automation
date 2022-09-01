const MESSAGE_API_ENDPOINT = Cypress.env('MESSAGE_API_DOMAIN') + 'api/message';
const DEFAULT_HEADER = { 'Content-Type': 'application/json' };
// it may take some time to get response due to cache implementation
const FIRST_MESSAGE_REQUEST_TIMEOUT = 60000;

function createSendMessageRequest(botId, messageText, lang, contextObj) {
  const requestBody = {
    key: botId,
    input: {
      text: messageText,
      meta: {},
    },
    language: lang,
    context: contextObj,
  };
  return JSON.stringify(requestBody);
}

function createContextObject(conversationId) {
  return {
    conversation_id: conversationId,
    explore: {
      suggestions: [],
      links: [],
      videos: [],
    },
  };
}

Cypress.Commands.add('createConversation', (botId) => {
  cy.sendFirstMessage(botId, 'Hi')
    .its('body')
    .then((body) => {
      return body.context.conversation_id;
    });
});

Cypress.Commands.add('sendFirstMessage', (botId, message, language = 'en') => {
  cy.request({
    method: 'POST',
    url: MESSAGE_API_ENDPOINT,
    body: createSendMessageRequest(botId, message, language, {}),
    headers: DEFAULT_HEADER,
    failOnStatusCode: false,
    log: false,
    timeout: FIRST_MESSAGE_REQUEST_TIMEOUT
  }).then((xhr) => {
    return xhr;
  });
});

Cypress.Commands.add('sendFirstMessageToOffice', (botId, campusId, officeId, message) => {
  const contextObject = {
    campus_id: parseInt(campusId, 10),
    office_id: parseInt(officeId, 10)
  };

  cy.request({
    method: 'POST',
    url: MESSAGE_API_ENDPOINT,
    body: createSendMessageRequest(botId, message, 'en', contextObject),
    headers: DEFAULT_HEADER,
    log: false
  }).then((xhr) => {
    return xhr;
  });
});

Cypress.Commands.add('sendMessage', (message, conversationId, botId) => {
  cy.request({
    method: 'POST',
    url: MESSAGE_API_ENDPOINT,
    body: createSendMessageRequest(botId, message, 'en', createContextObject(conversationId)),
    headers: DEFAULT_HEADER,
  });
});

Cypress.Commands.add('getChatbotConfig', (chatbotId) => {
  const chatbotConfigUrl = Cypress.env('MESSAGE_API_DOMAIN') + 'api/config?key=' + chatbotId;
  cy.request({
    method: 'GET',
    url: chatbotConfigUrl
  });
});

Cypress.Commands.add('sendFeedback', (chatbotId, conversationId, score, feedbackMessage) => {
  const chatbotFeedbackgUrl = Cypress.env('MESSAGE_API_DOMAIN') + 'api/feedback';
  const feedbackRequestBody = {
    key: chatbotId,
    conversation_id: conversationId,
    score: parseInt(score, 10),
    additionalFeedback: feedbackMessage
  };
  cy.request({
    method: 'POST',
    url: chatbotFeedbackgUrl,
    body: JSON.stringify(feedbackRequestBody),
    headers: DEFAULT_HEADER
  }).then((responseObject) => {
    expect(responseObject.status).to.eq(200);
  });
});
