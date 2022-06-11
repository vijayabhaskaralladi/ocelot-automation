import { And } from 'cypress-cucumber-preprocessor/steps';

And('Create file {string}', (fileName) => {
  const CREATE_FILE_UNIX = `touch cypress/temp/${fileName}`;
  const CREATE_FILE_WIN = `echo.> cypress\\temp\\${fileName}`;
  cy.get('@isWinSystem').then((isWinSystem) => {
    const script = isWinSystem ? CREATE_FILE_WIN : CREATE_FILE_UNIX;
    cy.exec(script).its('code').should('eq', 0);
  });
});

And('Prepare temp folder for the test', () => {
  const PREPARE_TEMP_FOLDER_SCRIPT_UNIX = 'mkdir -p cypress/temp; rm -rf cypress/temp/.*;';
  const PREPARE_TEMP_FOLDER_SCRIPT_WIN = 'mkdir cypress\\temp && del /q cypress\\temp\\*';
  cy.get('@isWinSystem').then((isWinSystem) => {
    const script = isWinSystem ? PREPARE_TEMP_FOLDER_SCRIPT_WIN : PREPARE_TEMP_FOLDER_SCRIPT_UNIX;
    cy.exec(script, { failOnNonZeroExit: false });
  });
});

And('Wait for marker file {string}', (fileName) => {
  // waits for fileName appearance in 'cypress/temp' folder
  const DELAY = 10000;
  const RETRIES = 10;

  const SHOW_ALL_FILES_IN_TEMP_FOLDER_UNIX = 'ls -a cypress/temp';
  const SHOW_ALL_FILES_IN_TEMP_FOLDER_WIN = 'dir /a:h cypress\\temp\\';

  cy.log(`Waiting for ${fileName} file`);

  const iterator = Array.from(Array(RETRIES));
  cy.wrap('false').as('isFilePresent');
  cy.wrap(iterator).each(() => {
    cy.get('@isFilePresent').then((value) => {
      if (value === 'false') {
        cy.wait(DELAY);
        cy.get('@isWinSystem').then((isWinSystem) => {
          const command = isWinSystem
            ? SHOW_ALL_FILES_IN_TEMP_FOLDER_WIN
            : SHOW_ALL_FILES_IN_TEMP_FOLDER_UNIX;
          cy.exec(command).then((result) => {
            if (result.stdout.includes(fileName)) {
              cy.wrap('true').as('isFilePresent');
            }
          });
        });
      }
    });
  });
});

And('Verify that download folder contains {string}', (fileName) => {
  const DOWNLOAD_FOLDER = Cypress.config('downloadsFolder');
  cy.exec(`ls -a ${DOWNLOAD_FOLDER}`).then((output) => {
    expect(output.stdout).to.have.string(fileName);
  });
});

And('Add reload event listener', () => {
  // Add this step before downloading files, see the attached link for more details
  // https://github.com/cypress-io/cypress/issues/14857
  cy.window()
    .document()
    .then((doc) => {
      doc.addEventListener('click', () => {
        setTimeout(() => {
          doc.location.reload();
        }, 5000);
      });
    });
});
