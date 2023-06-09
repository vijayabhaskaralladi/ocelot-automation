import { And, Before } from 'cypress-cucumber-preprocessor/steps';
import 'cypress-file-upload';
import {
  YES_RESPONSES_FOR_CAMPAIGNS,
  NO_RESPONSES_FOR_CAMPAIGNS,
  ENVIRONMENT_NAME,
  convertDataTableIntoDict, validateInputParamsAccordingToDict, extractBotHomePageUrl,
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
  cy.wrap(Cypress.env('GRAPHQL_URL')).as('GRAPHQL_URL');
  cy.wrap(Cypress.env('DRUPAL_URL')).as('DRUPAL_URL');

  // Binary Campaigns can accept different Y/N answers.
  // Automation will use different Y/N message each run to check
  // that Campaigns can handle them
  const yesResponse =
    YES_RESPONSES_FOR_CAMPAIGNS[Math.floor(Math.random() * YES_RESPONSES_FOR_CAMPAIGNS.length)];
  const noResponse =
    NO_RESPONSES_FOR_CAMPAIGNS[Math.floor(Math.random() * NO_RESPONSES_FOR_CAMPAIGNS.length)];
  cy.wrap(yesResponse).as('randomYesResponse');
  cy.wrap(noResponse).as('randomNoResponse');

  // loading constants
  cy.fixture('constants').then((constants) => {
    for (const [key, value] of Object.entries(constants)) {
      cy.wrap(value, {log: false}).as(key);
    }
  });

  // loading constants for the specific environment
  cy.fixture(`envs/${ENVIRONMENT_NAME}/constants`).then((constants) => {
    for (const [key, value] of Object.entries(constants)) {
      cy.wrap(value, {log: false}).as(key);
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
  cy.replacePlaceholder(text).then((keyword) => {
    cy.task('log', `Click on: ${keyword}`);
    if (keyword.includes('^')) {
      cy.contains(tag,  new RegExp(`${keyword}`, 'g')).click({ force: true, timeout: 20000 });
    } else {
      cy.contains(tag, keyword).click({ force: true, timeout: 20000 });
    }
  });
});

And('Tag {string} with text {string} should {string}', (tag, text, expectedStatus) => {
  // Field 'text' supports 'OR' operator, for example:
  // Tag "div" with text "Agent|Bot" should "exist"
  validateStatus(expectedStatus);
  // we need different timeouts for 'exist' and 'not.exist'
  // 'exist' - check that element is present or wait till element appears
  // 'not.exist' - check that element is not present in the DOM without waiting
  const TIMEOUT = expectedStatus === 'not.exist' ? 1000 : 20000;
  cy.replacePlaceholder(text).then((textWithReplacedPlaceholder) => {
    cy.task('log', `Checking that text <${textWithReplacedPlaceholder}> <${expectedStatus}>`);
    if (textWithReplacedPlaceholder.includes('|')) {
      cy.contains(tag, new RegExp(`${textWithReplacedPlaceholder}`), { timeout: TIMEOUT }).should(expectedStatus);
    } else {
      cy.contains(tag, textWithReplacedPlaceholder, { timeout: TIMEOUT }).should(expectedStatus);
    }
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
  cy.replacePlaceholder(text).then((keyword) => {
    cy.containsElement(element, keyword).should('exist');
  });
});

And('Type {string} in {string}', (text, selector) => {
  // if 'text' contains variable: ${}, this function replaces it with its value from global storage
  cy.replacePlaceholder(text).then((textWithReplacedPlaceholder) => {
    cy.getElement(selector)
      .clear({ force: true })
      .type(textWithReplacedPlaceholder, { force: true });
    cy.task('log', `Typing: ${textWithReplacedPlaceholder}`);
  });
});

And('Verify that element {string} contains positive number', (selector) => {
  cy.getElement(selector)
    .invoke('text')
    .then((text) => {
      const parsedText = text.substring(0, 7).replace(/[^0-9.]/g, '');
      cy.log(`Extracted value: ${parsedText}`);
      cy.task('log', `Extracted value: ${parsedText}`);
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

And(
  'Verify that selector {string} contains {string} elements',
  (selector, numberOfElements) => {
    cy.getElement(selector).should('have.length', parseInt(numberOfElements, 10));
  },
);

And('Save number of elements with selector {string} as {string}',(selector, alias)=>{
  cy.get(selector).its('length').as(alias);
});

And('Verify that element {string} has the following text {string}', (selector, expectedText) => {
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
  cy.task('log', `Sleeping <${millis}> ms`);
  cy.wait(parseInt(millis, 10));
});

And('Create random phone number and save it as {string}', (alias) => {
  const randomNumber = Math.floor((Math.random() * 9000)+2244440000);
  cy.wrap(randomNumber.toString()).as(alias);
});

And('Create random number and save it as {string}', (alias) => {
  const randomNumber = Math.floor(Math.random() * 100000);
  cy.wrap(randomNumber.toString()).as(alias);
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
    cy.replacePlaceholder(urlSuffix).then((urlSuffixParsed) => {
      cy.visit(currentUrl + urlSuffixParsed);
    });
  });
});

And('Open chatbot {string}', (chatbotName) => {
  cy.task('log', `Opening ${chatbotName} chatbot`);
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

And('Wait for tag with text', (datatable) => {
  //Wait for
  //|tag    | p        |
  //|text   | Success  |
  //|timeout| 10000    |
  const data = convertDataTableIntoDict(datatable);
  const requiredParametersAndAcceptableValues = {
    tag: 'any',
    text: 'any',
    timeout: 'any'
  };
  validateInputParamsAccordingToDict(data, requiredParametersAndAcceptableValues);
  cy.replacePlaceholder(data.text).then((text) => {
    cy.contains(data.tag, text, { timeout: data.timeout}).should('exist');
  });
});

And('Attach file {string} to {string} input', (fileName, selectorPath) => {
  cy.getElement(selectorPath).attachFile(fileName);
});

And('Retrieve text from {string} and save as {string}', (selectorPath, alias) => {
  cy.getElement(selectorPath)
    .invoke('text')
    .then((text) => {
      cy.log(`Retrieved: ${text}`);
      cy.task('log', `Retrieved: ${text}`);
      cy.wrap(text.trim()).as(alias);
    });
});

And('Verify that {string} length is greater than {string}', (key, length) => {
  cy.get(`@${key}`).then((text) => {
    expect(text.length).to.be.at.least(parseInt(length, 10));
  });
});

And('Verify that {string} contains {string}', (key, substring) => {
  cy.replacePlaceholder(substring).then((keyword) => {
    cy.get(`@${key}`).then((text) => {
      expect(text).to.contain(keyword);
    });
  });
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
  cy.replacePlaceholder(value).then((val) => {
    cy.wrap(val).as(key);
  });
});

And('Check that difference between {string} and {string} is {string}', (alias1, alias2, expectedDif) => {
  cy.get(`@${alias1}`).then((num1) => {
    cy.get(`@${alias2}`).then((num2) => {
      // retrieved values may contain extra text, like '86 %' or '148 questions'
      // this function removes all non-numeric characters before comparing them
      const num1Parsed = Number.isInteger(num1) ? num1 : parseInt(num1.replace(/\D/g, ''), 10);
      const num2Parsed = Number.isInteger(num2) ? num2 : parseInt(num2.replace(/\D/g, ''), 10);
      const difference = Math.abs(num2Parsed - num1Parsed);
      expect(difference).to.be.equal(parseInt(expectedDif, 10));
    });
  });
});

And('Set switch {string} to {string}', (switchSelector, status) => {
  cy.getElement(switchSelector).invoke('attr','value').then(switchState => {
    cy.replacePlaceholder(status).then((setStatus) => {
      const isClickRequired = (String(switchState) === 'false' && setStatus === 'enabled')
          || (String(switchState) === 'true' && setStatus === 'disabled');
      if (isClickRequired) {
        cy.getElement(switchSelector).click({force:true});
      }
    });
  });
});

And('Set switch for checkbox {string} to {string}', (switchSelector, status) => {
  cy.getElement(switchSelector).parent('span').invoke('attr','Mui-checked').then(switchState => {
    cy.replacePlaceholder(status).then((setStatus) => {
      if((switchState === 'false' && setStatus === 'enabled')
          || (switchState === 'true' && setStatus === 'disabled')) {
        cy.getElement(switchSelector).click({force:true});
      }
    });
  });
});

And('Choose random value from {string} and save it as {string}', (list, key) => {
  // Example: Choose random value from "Office 1|Office 2|Office 3" and save it as "office"
  // this step will choose random value and save it as "office"
  // later you can use this variable, for example:
  // Type "${office}" in "some.input"
  const values = list.split('|');
  const randomIndex = Math.floor(Math.random() * values.length);
  cy.wrap(values[randomIndex]).as(key);
});

And('Save current date as {string} using {string} format', (key, format) => {
  // examples of supported formats:
  // mm/dd/yyyy - use it for content lock date
  // yyyy-mm-dd  - use it for conversation details(interactions/transcripts)
  const isFormatCorrect = format.includes('dd') && format.includes('mm') && format.includes('yyyy');
  if (!isFormatCorrect) {
    throw Error(`Unsupported date format ${format}`);
  }
  const denverTimeString = new Date().toLocaleString('en-US', {timeZone: 'America/Denver'});
  const today = new Date(denverTimeString);

  const twoDigitDay = ('0' + today.getDate()).slice(-2);
  const twoDigitMonth = ('0' + (today.getMonth() + 1)).slice(-2);
  const year = today.getFullYear();

  const date = format
    .replace('dd', twoDigitDay)
    .replace('mm', twoDigitMonth)
    .replace('yyyy', year);

  cy.wrap(date).as(key);
});

And('Save current month as {string}', (key) => {
  const months = ['January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'];
  const currentMonth = months[new Date().getMonth()];
  cy.wrap(currentMonth).as(key);
});

And('Save current year as {string}', (key) => {
  const currentYear = new Date().getFullYear();
  cy.wrap(currentYear).as(key);
});

And('Scroll to {string} element',(selector)=>{
  // this step accepts regular CSS selectors and path to selector value
  // from support/selectors.js file
  if (isSelector(selector)) {
    cy.get(selector).scrollIntoView();
  } else {
    cy.getElement(selector).scrollIntoView();
  }
});

And('Check that notification message {string} appeared',(expectedMessage)=>{
  cy.task('log', `Check that notification message has text ${expectedMessage}`);
  cy.checkNotificationMessage(expectedMessage);
});

And('Save number of elements with tag {string} and {string} text as {string}',(tag, text, alias)=>{
  cy.replacePlaceholder(text).then((keyword) => {
    cy.get(`${tag}:contains(${keyword})`).its('length').as(alias);
  });
});

And('Refresh the page', () => {
  cy.reload();
});

And('Open chatbot home page', () => {
  cy.task('log', 'Opening chatbot home page');
  cy.url().then((currentUrl) => {
    cy.visit(extractBotHomePageUrl(currentUrl));
  });
});

And('Find {string}', (text) => {
  // wait for 1+ line on the page
  // this selector supports custom questions, awaiting review questions,
  // canned responses, LC/campaigns transcripts, contacts
  const rowSelector = 'tbody>tr.MuiTableRow-root, ' +
      'div.AppContent-body>div>div>div.MuiAccordionSummary-root, ' +
      'div.AppContent-body>div>div>div.GeneralQuestion-panel, ' +
      '#main-content>div>div>div>div.MuiPaper-rounded, ' +
      'div.CannedResponse-summaryPrimary, ' +
      'div.MuiPaper-root > div > div.MuiAccordionSummary-content';
  cy.get(rowSelector).should('have.length.gte', 1);

  // type text in the search input
  cy.replacePlaceholder(text).then((searchText) => {
    cy.task('log', `Search ${searchText}`);
    const searchInput = 'input[type="search"], input[name="keywords"]';
    cy.get(searchInput).clear().type(searchText);
  });
});