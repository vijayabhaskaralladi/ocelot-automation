import {And} from 'cypress-cucumber-preprocessor/steps';
import {convertDataTableIntoDict, validateInputParamsAccordingToDict} from '../../support/utils';

const isServiceNowEnabled = (serviceStatusesResponse) => {
  const integrations = serviceStatusesResponse.body.data.getProvisionedIntegrations;
  const isServiceNowEnabled = integrations
    .filter(item => item.type === 'ServiceNow' && item.status === 'Enabled')
    .length === 1;
  return isServiceNowEnabled;
};

And('Enable Service Now', (datatable) => {
  const serviceNowData = convertDataTableIntoDict(datatable);
  const requiredParametersAndAcceptableValues = {
    baseUrl: 'any',
    authToken: 'any',
    contextualEntity: 'any'
  };
  validateInputParamsAccordingToDict(serviceNowData, requiredParametersAndAcceptableValues);

  cy.replacePlaceholder(serviceNowData.authToken).then((token) => {
    cy.replacePlaceholder(serviceNowData.contextualEntity).then((contextualEntity) => {
      cy.getServicesStatuses(token, contextualEntity).then((response)=>{
        if (isServiceNowEnabled(response)) {
          cy.contains('h2', 'ServiceNow')
            .parent('div.MuiCardContent-root')
            .next()
            .contains('span', 'Configure')
            .click();
        } else {
          cy.contains('h2', 'ServiceNow')
            .parent('div.MuiCardContent-root')
            .next()
            .contains('span', 'Enable')
            .click();
        }
      });
    });

    const baseUrlInput = 'input[name="baseUri"]';
    cy.get(baseUrlInput).clear().type(serviceNowData.baseUrl);
    cy.contains('span','Save').click();
    cy.contains('#notistack-snackbar', 'The configuration has been saved successfully!')
      .should('exist');
  });
});

And('Disable Service Now', (datatable) => {
  const requestTokens = convertDataTableIntoDict(datatable);
  const requiredParametersAndAcceptableValues = {
    authToken: 'any',
    contextualEntity: 'any'
  };
  validateInputParamsAccordingToDict(requestTokens, requiredParametersAndAcceptableValues);

  cy.replacePlaceholder(requestTokens.authToken).then((token) => {
    cy.replacePlaceholder(requestTokens.contextualEntity).then((contextualEntity) => {
      cy.getServicesStatuses(token, contextualEntity).then((response)=>{
        if (isServiceNowEnabled(response)) {
          cy.contains('h2', 'ServiceNow')
            .parent('div.MuiCardContent-root')
            .next()
            .contains('span', 'Disable')
            .click();
        }
      });
    });
  });
});