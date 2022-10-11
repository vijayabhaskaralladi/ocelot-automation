Cypress.Commands.add('getServicesStatuses', (token, contextualEntity) => {
  const headers = {
    'Content-Type': 'application/json',
    'authorization': token,
    'x-contextual-entity': contextualEntity
  };

  const getServicesRequestBody = {
    'operationName': 'GetIntegrationDetails',
    'variables': {},
    'query': 'query GetIntegrationDetails {\n  getAvailableIntegrations\n ' +
        ' getProvisionedIntegrations {\n    type\n    status\n    ' +
        'chatbotUuid\n    __typename\n  }\n}\n'
  };
  const url = `${Cypress.env('GRAPHQL_URL')}graphql`;

  cy.request({
    method: 'POST',
    url: url,
    body: JSON.stringify(getServicesRequestBody),
    headers: headers,
    log: false
  }).then((xhr) => {
    return xhr;
  });
});