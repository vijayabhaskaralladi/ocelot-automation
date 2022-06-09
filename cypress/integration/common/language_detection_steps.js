import { And } from 'cypress-cucumber-preprocessor/steps';

And('Convert CSV {string} to JSON and save as {string}', (csvFileName, jsonFileName) => {
  // cypress can work with JSON files quite good so we need to convert CSV to JSON
  // expected that input file has 3 columns: message, detectedLanguage, expectedLanguage
  cy.readFile(`cypress/fixtures/${csvFileName}`).then((csvString) => {
    const lines = csvString.split('\n');
    const validateArraySize = (arr, expectedSize) => {
      if (arr.length !== expectedSize) {
        throw new Error(`Error during parsing.. ${arr}`);
      }
    };
    // first line contains column names
    lines.shift();

    const jsonArray = [];
    lines.forEach((line) => {
      // message may be included in "" and contain ',' we need to handle this case
      const lastIndexOfQuote = line.lastIndexOf('"');
      if (lastIndexOfQuote === -1) {
        const cells = line.split(',');
        validateArraySize(cells, 3);
        jsonArray.push({
          message: cells[0],
          detectedLanguage: cells[1],
          expectedLanguage: cells[2],
        });
      } else {
        const cells = line.substring(lastIndexOfQuote + 2, line.length).split(',');
        validateArraySize(cells, 2);
        jsonArray.push({
          message: line.substring(0, lastIndexOfQuote).replaceAll('"', ''),
          detectedLanguage: cells[0],
          expectedLanguage: cells[1],
        });
      }
    });
    cy.writeFile(`cypress/fixtures/${jsonFileName}`, JSON.stringify(jsonArray));
  });
});

And('Verify that chatbot detects language according to {string}', (fileWithTestInputs) => {
  // ToDo: step looks overcomplicated, try to simplify it and reduce number of nested constructions
  cy.wrap(0).as('numberOfMismatches');
  cy.wrap(0).as('numberOfErrorCodes');
  cy.wrap([]).as('linesWithWrongDetectedLanguage');
  cy.fixture(fileWithTestInputs).then((inputs) => {
    cy.get('@activeChatbotId').then((botId) => {
      inputs.forEach((input) => {
        cy.sendFirstMessage(botId, input.message).then((xhr) => {
          if (xhr.status !== 200) {
            cy.log(`Status: ${xhr.status}. Message: ${input.message}.`);
            cy.log(xhr.body);
            cy.get('@numberOfErrorCodes').then((numberOfErrorCodes) => {
              cy.wrap(numberOfErrorCodes + 1).as('numberOfErrorCodes');
            });
          } else if (xhr.body.language !== input.expectedLanguage) {
            cy.get('@numberOfMismatches').then((numberOfMismatches) => {
              cy.wrap(numberOfMismatches + 1).as('numberOfMismatches');
            });
            cy.log(`Message: ${input.message}.`);
            cy.log(`Expected language: ${input.expectedLanguage}`);
            cy.log(`Actual language: ${xhr.body.language}`);
            cy.get('@linesWithWrongDetectedLanguage').then((linesWithWrongDetectedLanguage) => {
              linesWithWrongDetectedLanguage.push({
                message: input.message,
                detectedLanguage: input.detectedLanguage,
                expectedLanguage: input.expectedLanguage,
                actualLanguage: xhr.body.language,
              });
              cy.wrap(linesWithWrongDetectedLanguage).as('linesWithWrongDetectedLanguage');
            });
          }
        });
      });
    });
  });
});

// ToDo: move to common steps
And('Verify that {string} should equal {string}', (key, expectedValue) => {
  cy.get(`@${key}`, { timeout: 100 }).should('eq', parseInt(expectedValue, 10));
});

And('Save JSON object stored as {string} to {string}', (key, fileName) => {
  cy.get(`@${key}`).then((jsonObject) => {
    cy.writeFile(`cypress/fixtures/${fileName}`, JSON.stringify(jsonObject));
  });
});
