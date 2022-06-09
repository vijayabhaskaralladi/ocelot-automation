const MESSAGE_API_ENDPOINT = Cypress.env('MESSAGE_API_DOMAIN') + 'api/message';
const DEFAULT_HEADER = { 'Content-Type': 'application/json' };

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
