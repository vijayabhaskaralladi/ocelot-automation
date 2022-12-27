import {And} from 'cypress-cucumber-preprocessor/steps';
import {getValueByPath} from '../../support/utils';

And('Set operator status to {string}', (status) => {
  const acceptableValues = ['available', 'away'];
  if (!acceptableValues.includes(status)) {
    throw Error(`Unsupported value ${status}`);
  }
  cy.log(`Setting operator status: ${status}`);
  const profile = 'header>div>button>span>span.MuiBadge-root>div';
  cy.get(profile).click({force: true});

  const profileMenu = 'ul[role="menu"]';
  const chatStatusSwitch = 'span>[type="checkbox"]';
  cy.replacePlaceholder('${GRAPHQL_URL}graphql').then((url) => {
    cy.intercept(url, (req) => {
      if (JSON.stringify(req.body).includes('setLiveChatOperatorStatus')) {
        req.alias = 'changeStatusRequest';
      }
    });
  });
  cy.get(profileMenu).then((body) => {
    const isOperatorOnline = body.find('span.Mui-checked').length > 0;
    if ((isOperatorOnline && status === 'away') ||
      (!isOperatorOnline && status === 'available')) {
      cy.get(chatStatusSwitch).click({force: true});
      // ToDo: sometimes page doesn't contain notifications, will uncomment later
      // cy.get('#notistack-snackbar', {timeout: 5000}).should('be.visible');
    }
  });
  cy.wait('@changeStatusRequest').then((responseObject) => {
    expect(responseObject.response.statusCode).to.eq(200);
    const fieldName = 'response.body.data.setLiveChatOperatorStatus';
    const expectedStatus = status.toLowerCase();
    const actualStatus = getValueByPath(responseObject, fieldName).toLowerCase();
    expect(actualStatus).to.eq(expectedStatus);
  });
  // closing the menu
  cy.get('body').click(0,0);
});
