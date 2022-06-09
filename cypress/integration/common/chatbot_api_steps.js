import { And } from 'cypress-cucumber-preprocessor/steps';
import { ENVIRONMENT_NAME } from '../../support/utils';

And('API: Select {string} chatbot', (chatbotName) => {
  cy.fixture(`envs/${ENVIRONMENT_NAME}/chatbots`).then((chatbots) => {
    cy.wrap(chatbots[chatbotName].id).as('activeChatbotId');
  });
});

And('API: Create dialog and save conversation_id as {string}', (conversationIdAlias) => {
  cy.get('@activeChatbotId').then((chatbotId) => {
    cy.createConversation(chatbotId).then((conversationId) => {
      cy.wrap(conversationId).as(conversationIdAlias);
    });
  });
});

And('API: Send message {string} for {string} conversation', (message, conversationIdAlias) => {
  cy.get(`@${conversationIdAlias}`).then((conversationId) => {
    cy.get('@activeChatbotId').then((chatbotId) => {
      cy.sendMessage(message, conversationId, chatbotId);
    });
  });
  cy.wait(2000);
});

And('API: Send first message {string} and save response as {string}', (message, responseAlias) => {
  cy.get('@activeChatbotId').then((chatbotId) => {
    cy.replacePlaceholder(message).then((msg) => {
      cy.sendFirstMessage(chatbotId, msg).as(responseAlias);
    });
  });
  cy.wait(1000);
});

And(
  'API: Set language {string} and send message {string} and save response as {string}',
  (langCode, message, responseAlias) => {
    cy.get('@activeChatbotId').then((chatbotId) => {
      cy.sendFirstMessage(chatbotId, message, langCode).as(responseAlias);
    });
    cy.wait(1000);
});
