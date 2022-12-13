import { And } from 'cypress-cucumber-preprocessor/steps';
import { ENVIRONMENT_NAME } from '../../support/utils';

And('Login as {string}', (userName) => {
  cy.fixture(`envs/${ENVIRONMENT_NAME}/users`).then((users) => {
    cy.login(users[userName].email, users[userName].password, users[userName].token);
  });
});

And('Login using random user from the list', (datatable) => {
  cy.fixture(`envs/${ENVIRONMENT_NAME}/users`).then((users) => {
    const userKeys = [];
    const input = datatable.rawTable;
    for (let i = 0; i < input.length; i++) {
      userKeys.push(input[i][0]);
    }
    const randomUserKey = userKeys[Math.floor(Math.random() * userKeys.length)];
    cy.login(users[randomUserKey].email, users[randomUserKey].password, users[randomUserKey].token);
  });
});

And('Client Admin test setup', () => {
  cy.visit('/');
  cy.title().then((title) => {
    if (!title.includes('Home')) {
      cy.fixture(`envs/${ENVIRONMENT_NAME}/users`).then((users) => {
        const defaultUser = users.defaultUser;
        cy.login(defaultUser.email, defaultUser.password, defaultUser.token);
      });
    }
  });
});

And('Logout', () => {
  cy.window().then(win => win.sessionStorage.clear());
  cy.clearCookies();
  cy.clearLocalStorage();
});

