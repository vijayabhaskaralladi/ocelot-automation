import { And } from 'cypress-cucumber-preprocessor/steps';
import {convertDataTableIntoDict, validateInputParamsAccordingToDict} from '../../support/utils';

And('Manage subscriptions', (datatable) => {
  // ToDo: update step to check initial value of the checkbox
  const subscriptionsData = convertDataTableIntoDict(datatable);
  const requiredParametersAndAcceptableValues = {
    campaignName: 'any',
    action: ['subscribe', 'unsubscribe']
  };
  validateInputParamsAccordingToDict(subscriptionsData, requiredParametersAndAcceptableValues);

  cy.task('log', `Changing subscription for <${subscriptionsData.campaignName}>. Action: <${subscriptionsData.action}>`);
  const manageSubscriptionsButton = 'button';
  cy.get(manageSubscriptionsButton).contains('Manage Subscriptions').click({force:true});
  // waiting for 'Manage Subscriptions' table
  cy.contains('td', 'Draft').should('exist');
  cy.replacePlaceholder(subscriptionsData.campaignName).then((campaignName) => {
    const searchInput = 'input[placeholder="Search campaigns..."]';
    cy.get(searchInput).click().clear().type(campaignName);
    const campaignRow = '[aria-label="Manage Subscriptions"]>tbody>tr';
    const subscribeCheckbox = `input[aria-label="Subscribe to ${campaignName}"]`;
    //waiting for only one result
    cy.get(campaignRow).should('have.length', 1);

    cy.replacePlaceholder('${GRAPHQL_URL}graphql').then((url) => {
      cy.intercept(url, (req) => {
        if (JSON.stringify(req.body).includes('updateCampaign')) {
          req.alias = 'subscriptionsRequest';
        }
      });
    });
    cy.get(subscribeCheckbox).click();
    cy.wait('@subscriptionsRequest');
    cy.wait(1000);
    const doneButton = '.MuiDialogActions-root>button';
    cy.get(doneButton).click();
  });
});