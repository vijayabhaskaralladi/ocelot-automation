import { And } from 'cypress-cucumber-preprocessor/steps';
import { getValueByPath } from '../../support/utils';

And('Intercept {string} as {string}', (url, alias) => {
  // url may include request method 'REQUEST_METHOD: URL'
  // Also 'url' may contain variable name, for example: 'POST: ${env_variable_name}'
  let urlWithReplacedPlaceholder = url;
  // ToDo: replace 'if' block:
  // https://stackoverflow.com/questions/52665091/cypress-if-else-switch-case-doesnt-work

  const matchedStrings = url.match(/\${([^}]*)}/);
  if (matchedStrings && matchedStrings[1]) {
    urlWithReplacedPlaceholder = url.replace(matchedStrings[0], Cypress.env(matchedStrings[1]));
    cy.log(urlWithReplacedPlaceholder);
  }
  if (url.includes(': ')) {
    cy.intercept(
      urlWithReplacedPlaceholder.split(': ')[0],
      urlWithReplacedPlaceholder.split(': ')[1],
    ).as(alias);
  } else {
    cy.intercept(urlWithReplacedPlaceholder).as(alias);
  }
});

And(
  'Intercept {string} with {string} keyword in the response as {string}',
  (url, keyword, alias) => {
    cy.replacePlaceholder(url).then((urlWithReplacedPlaceholder) => {
      cy.intercept(urlWithReplacedPlaceholder, (req) => {
        if (JSON.stringify(req.body).includes(keyword)) {
          req.alias = alias;
        }
      });
    });
  },
);

And('Wait for {string} and save it as {string}', (responseAlias, name) => {
  cy.wait(`@${responseAlias}`).then((responseObject) => {
    cy.wrap(responseObject).as(name);
  });
});

And('Wait for {string} network call', (responseAlias) => {
  cy.wait(`@${responseAlias}`, { timeout: 15000 });
  cy.wait(1000);
});

And('Verify that response {string} has status code {string}', (responseAlias, statusCode) => {
  cy.task('log', `Verify that ${responseAlias} has status code ${statusCode}`);
  cy.get(`@${responseAlias}`).then((responseObject) => {
    // storage may have 2 different response objects
    if (responseObject.body === undefined) {
      expect(responseObject.response.statusCode).to.eq(parseInt(statusCode, 10));
    } else {
      expect(responseObject.status).to.eq(parseInt(statusCode, 10));
    }
  });
});

And(
  'Verify that response {string} has field {string} equal to {string}',
  (responseAlias, fieldName, expectedValue) => {
    // Field name supports indexes only for the last element:
    // name1.name2.name3[0] - ok
    // name1.name2[0].name3 - will not work
    cy.get(`@${responseAlias}`).then((responseObject) => {
      cy.replacePlaceholder(expectedValue).then((expectedValueReplaced) => {
        cy.task('log', `Verify that <${responseAlias}> has field <${fieldName}> equal to <${expectedValueReplaced}>`);
        if (fieldName.includes('[') && fieldName.includes(']')) {
          const startIndex = fieldName.indexOf('[');
          const endIndex = fieldName.indexOf(']');

          const path = fieldName.substring(0, startIndex);
          const index = parseInt(fieldName.substring(startIndex + 1, endIndex), 10);

          const array = getValueByPath(responseObject, path);
          const field = array[index];
          cy.task('log', `Extracted value: ${field}`).then(() => {
            expect(field.toString()).to.eq(expectedValueReplaced);
          });
        } else {
          const field = getValueByPath(responseObject, fieldName);
          cy.task('log', `Extracted value: ${field}`).then(() => {
            expect(field.toString()).to.eq(expectedValueReplaced);
          });
        }
      });
    });
  },
);

And(
  'Verify that bot response {string} contains {string} message {string}',
  (responseAlias, expectedMessage, langCode) => {
    cy.get(`@${responseAlias}`).then((responseObject) => {
      const botResponse = responseObject.body.output.text[langCode];
      cy.task('log', `Bot response <${botResponse}> should contain <${expectedMessage}>`).then(() => {
        expect(botResponse).to.contain(expectedMessage);
      });
    });
  }
);

And('Retrieve {string} from {string} and save as {string}', (fieldPath, alias, saveAsAlias) => {
  cy.get(`@${alias}`).its(fieldPath).as(saveAsAlias);
});
