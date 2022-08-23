import {And} from 'cypress-cucumber-preprocessor/steps';
import {ENVIRONMENT_NAME} from '../../support/utils';
import {convertDataTableIntoDict, validateInputParamsAccordingToDict} from '../../support/utils';

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

And('API: Send message', (datatable) => {
  const messageRequestData = convertDataTableIntoDict(datatable);
  const requiredParametersAndAcceptableValues = {
    conversationIdAlias: 'any',
    message: 'any'
  };
  validateInputParamsAccordingToDict(messageRequestData, requiredParametersAndAcceptableValues);

  cy.get(`@${messageRequestData.conversationIdAlias}`).then((conversationId) => {
    cy.get('@activeChatbotId').then((chatbotId) => {
      cy.replacePlaceholder(messageRequestData.message).then((msg) => {
        cy.sendMessage(msg, conversationId, chatbotId).then((response) => {
          if ('saveResponseAs' in messageRequestData) {
            cy.wrap(response).as(messageRequestData.saveResponseAs);
          }
        });
      });
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

And('API: Set language {string} and send message {string} and save response as {string}',
  (langCode, message, responseAlias) => {
    cy.get('@activeChatbotId').then((chatbotId) => {
      cy.sendFirstMessage(chatbotId, message, langCode).as(responseAlias);
    });
    cy.wait(1000);
  });

And('API: Check that chatbot welcome message is {string}', (expectedWelcomeMessage) => {
  cy.replacePlaceholder(expectedWelcomeMessage).as('expectedWelcomeMessage');
  cy.get('@activeChatbotId').then((chatbotId) => {
    const chatbotConfigUrl = Cypress.env('MESSAGE_API_DOMAIN') + 'api/config?key=' + chatbotId;
    cy.wrap(chatbotConfigUrl).as('chatbotConfigUrl');
  });

  const DELAY = 500;
  const RETRIES = 10;

  const iterator = Array.from(Array(RETRIES));
  cy.wrap(false).as('isWelcomeMessageCorrect');
  cy.wrap(iterator).each(() => {
    cy.get('@isWelcomeMessageCorrect', {log: false}).then((isWelcomeMessageCorrect) => {
      if (isWelcomeMessageCorrect === false) {
        cy.wait(DELAY);
        cy.get('@chatbotConfigUrl').then((chatbotConfigUrl) => {
          cy.request({
            method: 'GET',
            url: chatbotConfigUrl
          }).then((responseObject) => {
            expect(responseObject.status).to.eq(200);
            cy.get('@expectedWelcomeMessage').then((expectedMessage) => {
              const retrievedWelcomeMessage = responseObject.body.hello.en;
              cy.log(`Retrieved welcome message: ${retrievedWelcomeMessage}`);
              cy.log(`Expected welcome message: ${expectedMessage}`);
              if (retrievedWelcomeMessage.includes(expectedMessage)) {
                cy.wrap(true).as('isWelcomeMessageCorrect');
              }
            });
          });
        });
      }
    });
  });
  cy.get('@isWelcomeMessageCorrect').then((isWelcomeMessageCorrect) => {
    expect(isWelcomeMessageCorrect).to.be.equal(true);
  });
});

And('API: Get chatbot config and save it as {string}', (responseAlias) => {
  cy.get('@activeChatbotId').then((chatbotId) => {
    cy.getChatbotConfig(chatbotId).as(responseAlias);
  });
  cy.wait(1000);
});
