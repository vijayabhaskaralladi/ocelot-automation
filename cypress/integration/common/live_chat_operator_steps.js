import {And} from 'cypress-cucumber-preprocessor/steps';

And('Set operator status to {string}', (status) => {
  const acceptableValues = ['available', 'away'];
  if (!acceptableValues.includes(status)) {
    throw Error(`Unsupported value ${status}`);
  }
  cy.log(`Setting operator status: ${status}`);
  const profile = 'header>div>button>span>span>span.MuiBadge-root>div';
  cy.get(profile).click({force: true});

  const profileMenu = 'ul[role="menu"]';
  const chatStatusSwitch = 'span>[type="checkbox"]';
  cy.get(profileMenu).then((body) => {
    const isOperatorOnline = body.find('span.Mui-checked').length > 0;
    if ((isOperatorOnline && status === 'away') ||
      (!isOperatorOnline && status === 'available')) {
      cy.get(chatStatusSwitch).click();
      // ToDo: sometimes page doesn't contain notifications, will uncomment later
      // cy.get('#notistack-snackbar', {timeout: 5000}).should('be.visible');
    }
  });
  // closing the menu
  cy.get('body').click(0,0);
});
