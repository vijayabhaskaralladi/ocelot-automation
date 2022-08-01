import { And, Before } from 'cypress-cucumber-preprocessor/steps';
import 'cypress-file-upload';
import {
  YES_RESPONSES_FOR_CAMPAIGNS,
  NO_RESPONSES_FOR_CAMPAIGNS,
} from '../../support/utils';

// ToDo: move this function to something like utils.js
function isSelector(selectorText) {
  // this function verifies whether selectorText is selector or path for selectors.json
  return new RegExp(/[[\]()/\\#>]|div|span|td/).test(selectorText);
}

// ToDo: move this function to something like utils.js
function validateStatus(status) {
  const acceptableValues = ['exist', 'not.exist'];
  if (!acceptableValues.includes(status)) {
    throw Error(`Unsupported value ${status}`);
  }
}

// ToDo: move this function to something like utils.js
function convertCheckboxStatusIntoChainer(state) {
  const acceptableValues = ['checked', 'unchecked'];
  if (!acceptableValues.includes(state)) {
    throw Error(`Unsupported value ${state}`);
  }
  return state === 'checked' ? 'be.checked' : 'not.be.checked';
}

Before(() => {
  cy.wrap(Cypress.platform.includes('win32')).as('isWinSystem');
  cy.wrap(Cypress.env('GRAPHQL_URL')).as('GRAPHQL_URL');
  cy.wrap(Cypress.env('DRUPAL_URL')).as('DRUPAL_URL');
  cy.wrap(Cypress.env('PROVISION_NUMBER')).as('PROVISION_NUMBER');

  // Binary Campaigns can accept different Y/N answers.
  // Automation will use different Y/N message each run to check
  // that Campaigns can handle them
  const yesResponse =
    YES_RESPONSES_FOR_CAMPAIGNS[Math.floor(Math.random() * YES_RESPONSES_FOR_CAMPAIGNS.length)];
  const noResponse =
    NO_RESPONSES_FOR_CAMPAIGNS[Math.floor(Math.random() * NO_RESPONSES_FOR_CAMPAIGNS.length)];
  cy.wrap(yesResponse).as('randomYesResponse');
  cy.wrap(noResponse).as('randomNoResponse');
  cy.fixture('constants').then((constants) => {
    for (const [key, value] of Object.entries(constants)) {
      cy.wrap(value).as(key);
    }
  });
});

And('Open {string} menu item', (menuItem) => {
  cy.openMenuItem(menuItem);
});

And('Verify that page title is {string}', (pageTitle) => {
  cy.verifyMainTitle(pageTitle);
});

And('Verify that browser tab title contains {string}', (browserTabTitle) => {
  cy.title().should('contain', browserTabTitle);
});

And('Verify that page contains titles {string}', (expectedTitles) => {
  const expectedTitlesList = expectedTitles.split(';');
  cy.wrap(expectedTitlesList).each((titleText) => {
    if (titleText !== '') {
      const TITLE_SELECTOR = '.MuiTypography-root';
      cy.contains(TITLE_SELECTOR, titleText).should('exist');
    }
  });
});

And('Click on {string}', (selector) => {
  // this step accepts regular CSS selectors and path to selector value
  // from support/selectors.js file
  if (isSelector(selector)) {
    cy.get(selector).click({ force: true });
  } else {
    cy.getElement(selector).click({ force: true });
  }
});

And('Click on tag {string} which contains text {string}', (tag, text) => {
  cy.contains(tag, text).click({ force: true });
});

And('Tag {string} with text {string} should {string}', (tag, text, expectedStatus) => {
  validateStatus(expectedStatus);
  // we need different timeouts for 'exist' and 'not.exist'
  // 'exist' - check that element is present or wait till element appears
  // 'not.exist' - check that element is not presnent in the DOM without waiting
  const TIMEOUT = expectedStatus === 'not.exist' ? 1000 : 20000;
  cy.replacePlaceholder(text).then((textWithReplacedPlaceholder) => {
    cy.contains(tag, textWithReplacedPlaceholder, { timeout: TIMEOUT }).should(expectedStatus);
  });
});

And('Element {string} should {string}', (selector, expectedStatus) => {
  validateStatus(expectedStatus);
  if (isSelector(selector)) {
    cy.get(selector).should(expectedStatus);
  } else {
    cy.getElement(selector).should(expectedStatus);
  }
});

And('Verify that page contains element {string} with text {string}', (element, text) => {
  cy.containsElement(element, text).should('exist');
});

And('Type {string} in {string}', (text, selector) => {
  // if 'text' contains variable: ${}, this function replaces it with its value from global storage
  cy.replacePlaceholder(text).then((textWithReplacedPlaceholder) => {
    cy.getElement(selector).clear().type(textWithReplacedPlaceholder, { force: true });
  });
});

And('Verify that element {string} contains positive number', (selector) => {
  cy.getElement(selector)
    .invoke('text')
    .then((text) => {
      const parsedText = text.substring(0, 7).replace(/[^0-9.]/g, '');
      cy.log(`Extracted value: ${parsedText}`);
      assert.isAtLeast(parseInt(parsedText, 10), 0);
    });
});

And('Verify that element {string} has number greater than {string}', (selector, number) => {
  cy.getElement(selector)
    .invoke('text')
    .then((text) => {
      const parsedText = text.substring(0, 7).replace(/[^0-9.]/g, '');
      cy.log(`Extracted value: ${parsedText}`);
      assert.isAtLeast(parseInt(parsedText, 10), parseInt(number, 10));
    });
});

And(
  'Verify that selector {string} contains more than {string} elements',
  (selector, minimumNumberOfElements) => {
    cy.getElement(selector).should('have.length.gte', parseInt(minimumNumberOfElements, 10));
  },
);

And('Verify that element {string} contains the following text {string}',
  (selector, expectedText) => {
    cy.replacePlaceholder(expectedText).then((expectedTextReplaced) => {
      cy.getElement(selector).should('have.text', expectedTextReplaced);
    });
  });

And('Select {string} from {string}', (itemSelector, menuSelector) => {
  cy.getElement(menuSelector).click();
  cy.get(itemSelector, { timeout: 1500 }).should('be.visible');
  cy.getElement(itemSelector).click();
});

And('Wait {string}', (millis) => {
  cy.wait(parseInt(millis, 10));
});

And('Create random number and save it as {string}', (alias) => {
  const randomNumber = Math.floor(Math.random() * 10000);
  cy.wrap(randomNumber.toString()).as(alias);
});

And('Visit base URL', () => {
  cy.visit('/');
});

And('Visit {string}', (url) => {
  cy.replacePlaceholder(url).then((parsedUrl) => {
    cy.visit(parsedUrl);
  });
});

And('URL should include {string}', (substring) => {
  cy.url().should('include', substring);
});

And('Add {string} to the current URL', (urlSuffix) => {
  cy.url().then((currentUrl) => {
    cy.visit(currentUrl + urlSuffix);
  });
});

And('Open chatbot {string}', (chatbotName) => {
  cy.openChatbot(chatbotName);
});

And('Verify that page contains text {string}', (text) => {
  cy.replacePlaceholder(text).then((textWithReplacedPlaceholder) => {
    cy.contains(textWithReplacedPlaceholder).should('exist');
  });
});

And('Wait for element {string}', (selectorPath) => {
  cy.getElement(selectorPath).should('exist');
});

And('Attach file {string} to {string} input', (fileName, selectorPath) => {
  cy.getElement(selectorPath).attachFile(fileName);
});

And('Retrieve text from {string} and save as {string}', (selectorPath, alias) => {
  cy.getElement(selectorPath)
    .invoke('text')
    .then((text) => {
      cy.log(`Retrieved: ${text}`);
      cy.wrap(text).as(alias);
    });
});

And('Verify that {string} length is greater than {string}', (key, length) => {
  cy.get(`@${key}`).then((text) => {
    expect(text.length).to.be.at.least(parseInt(length, 10));
  });
});

And('Click on last element {string}', (selector) => {
  cy.getElement(selector).last().click({ force: true });
  cy.getElement(selector).last().click({ force: true });
});

And(
  'Verify that element {string} has attribute {string} with value {string}',
  (selector, attributeName, expectedValue) => {
    cy.getElement(selector).invoke('attr', attributeName).should('eq', expectedValue);
  },
);

And('Verify that checkbox {string} is {string}', (selector, expectedState) => {
  cy.getElement(selector).should(convertCheckboxStatusIntoChainer(expectedState));
});

And('Save {string} as {string}', (value, key) => {
  cy.wrap(value).as(key);
});
