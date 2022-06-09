import { And } from 'cypress-cucumber-preprocessor/steps';
import { ENVIRONMENT_NAME } from '../../support/utils';

And('Verify that embedded script contains id for {string} chatbot', (chatbotName) => {
  cy.fixture(`envs/${ENVIRONMENT_NAME}/chatbots`).then((chatbots) => {
    cy.getElement('chatbot.embedding.scriptText')
      .invoke('text')
      .then((text) => {
        expect(text).to.contain(chatbots[chatbotName].id);
      });
  });
});
