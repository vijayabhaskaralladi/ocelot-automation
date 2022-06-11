import { And } from 'cypress-cucumber-preprocessor/steps';

And('Send SMS {string} to {string} from {string}', (msg, to, from) => {
  cy.replacePlaceholder(msg).then((message) => {
    cy.replacePlaceholder(to).then((toWithReplacedPlaceholder) => {
      const toNumber = toWithReplacedPlaceholder.replace(/\D/g, '');
      const fromNumber = from.replace(/\D/g, '');
      cy.log(`Sending <${message}> to <${toNumber}> from <${fromNumber}>`);
      const dataObj = { message, toNumber, fromNumber };
      cy.task('sendSms', dataObj);
    });
  });
});

And('Verify that {string} number received {string} message', (phoneNum, expectedMsg) => {
  // the step verifies that Twilio send message to specified number
  const number = phoneNum.replace(/\D/g, '');
  cy.replacePlaceholder(expectedMsg).then((message) => {
    const dataObj = { message, number };
    cy.task('verifyThatNumberReceivedSms', dataObj).should('have.length', 1);
  });
});

And('Verify that last SMS for number {string} has text {string}', (phoneNum, text) => {
  const number = phoneNum.replace(/\D/g, '');
  cy.replacePlaceholder(text).then((uniqueText) => {
    cy.task('getLastIncomingSmsForNumber', number).its('body').should('contain.text', uniqueText);
  });
});
