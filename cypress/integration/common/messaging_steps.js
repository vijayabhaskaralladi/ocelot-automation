import {And} from 'cypress-cucumber-preprocessor/steps';
import {convertDataTableIntoDict, validateInputParamsAccordingToDict} from '../../support/utils';

And('Send 1:1 message', (datatable) => {
  const messageData = convertDataTableIntoDict(datatable);
  const requiredParametersAndAcceptableValues = {
    message: 'any',
    to: 'any',
    from: 'any'
  };
  validateInputParamsAccordingToDict(messageData, requiredParametersAndAcceptableValues);
  cy.openCreateOneToOneTextModal();

  const fromDropdown = 'input[aria-labelledby="phoneNumberListSelect"]';
  cy.get(fromDropdown).click();
  cy.wait(500);
  cy.replacePlaceholder(messageData.from).then((from) => {
    cy.contains('span', from).click({force: true});
  });

  const toInput = 'input[name="smsTo"]';
  cy.replacePlaceholder(messageData.to).then((to) => {
    cy.get(toInput).type(to);
  });

  const messageInput = 'div[aria-label="Rich Text Editor, Message"] > p';
  cy.replacePlaceholder(messageData.message).then((message) => {
    cy.get(messageInput).type(message);
  });

  cy.contains('button', 'Send').click();
});