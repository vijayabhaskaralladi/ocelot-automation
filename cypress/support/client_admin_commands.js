import { ENVIRONMENT_NAME } from './utils';

Cypress.Commands.add('login', (username, password, secret) => {
  cy.log(`Log in as ${username}`);
  cy.task('log', `Login as ${username}`);
  cy.visit('/');
  cy.get('#edit-username').type(username);
  cy.get('#edit-password').type(password).type('{enter}');
  cy.task('generateOTP', secret).then((token) => {
    cy.get('#edit-one-time-password').type(token);
  });
  cy.get('#edit-submit').click();
});

Cypress.Commands.add('openMenuItem', (menuItem) => {
  /*
   * Example of menuItem:
   * Home
   * Embedding->Get Code
   * Analytics->Live Chat->Dashboard
   */
  cy.log(`Opening ${menuItem}`);
  cy.task('log', `Opening ${menuItem}`);
  // checking isMenuDrawerOpened
  cy.get('#__next')
    .invoke('attr', 'aria-hidden')
    .then((ariaHidden) => {
      const isMenuOpened = ariaHidden === 'true';
      if (!isMenuOpened) {
        cy.log('Opening menu drawer');
        const menuButton = 'button[aria-label="Open menu drawer"]';
        cy.get(menuButton).click({force: true});
        cy.wait(500);
      }
    });
  const items = menuItem.replace('Knowledgebase', 'Knowledge base').split('->');
  const menuItemSelector = '[role="presentation"]>.AppDrawer-paper li>.MuiButton-root';
  items.forEach((item) => {
    cy.contains(menuItemSelector, item)
      .parent()
      .then((element) => {
        const isItemExpanded = element.find('div.MuiCollapse-entered').length > 0;
        if (!isItemExpanded) {
          cy.contains(menuItemSelector, item).click({force: true});
          cy.wait(1000);  
        }
      });
  });

  cy.verifyThatNoErrorsDisplayed();
});

// ToDo: remove if unused
Cypress.Commands.add('clientAdminTestSetup', () => {
  cy.visit('/');
  cy.title().then((title) => {
    if (!title.includes('Home')) {
      cy.loginAsAdmin();
    }
  });
});

Cypress.Commands.add('verifyMainTitle', (expectedPageTitle) => {
  cy.contains('h1.MuiTypography-root', expectedPageTitle).should('exist');
});

Cypress.Commands.add('verifyThatPageContainsTitles', (expectedTitles) => {
  expectedTitles.forEach((text) => {
    cy.get('h2.MuiTypography-root', { timeout: 10000 }).contains(text).should('exist');
  });
});

Cypress.Commands.add('verifyThatNoErrorsDisplayed', () => {
  cy.get('div[data-testid="snackbar-error"]>div').should('not.exist');
});

Cypress.Commands.add('replacePlaceholderAndSaveAs', (textWithPlaceholder, saveAsKey) => {
  // ToDo: this command will be fully replaced with cy.replacePlaceholder()
  cy.replacePlaceholder(textWithPlaceholder).as(saveAsKey);
});

Cypress.Commands.add('replacePlaceholder', (textWithPlaceholder) => {
  /*
   * Replaces ${variableName} placeholder with its value and saves via cy.wrap
   */
  const variableStartPosition = textWithPlaceholder.indexOf('${');
  const variableEndPosition = textWithPlaceholder.indexOf('}');
  if (variableStartPosition >= 0 && variableEndPosition >= 0) {
    const alias = textWithPlaceholder.substring(variableStartPosition + 2, variableEndPosition);
    cy.log(`Alias: ${alias}`);
    cy.get(`@${alias}`).then((value) => {
      const textWithReplacedPlaceholder =
        textWithPlaceholder.slice(0, variableStartPosition) +
        value +
        textWithPlaceholder.slice(variableEndPosition + 1, textWithPlaceholder.length);

      cy.log(textWithReplacedPlaceholder);
      return cy.wrap(textWithReplacedPlaceholder);
    });
  } else {
    return cy.wrap(textWithPlaceholder);
  }
});

Cypress.Commands.add('openChatbot', (chatbotName) => {
  cy.wrap(chatbotName).as('currentChatbot');
  cy.fixture(`envs/${ENVIRONMENT_NAME}/chatbots`).then((chatbots) => {
    cy.get('head>title')
      .invoke('text')
      .then((title) => {
        if (!title.includes(chatbots[chatbotName].title)) {
          cy.visit(`/${chatbots[chatbotName].url}`);
        }
      });
  });
});

Cypress.Commands.add('checkNotificationMessage', (expectedMessage) => {
  cy.contains('#notistack-snackbar', expectedMessage).should('exist');
});

