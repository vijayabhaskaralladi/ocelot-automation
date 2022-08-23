import { And } from 'cypress-cucumber-preprocessor/steps';

const DOWNLOAD_FOLDER = Cypress.config('downloadsFolder');

// ToDo: remove if unused
And('Create file {string}', (fileName) => {
  const CREATE_FILE_UNIX = `touch cypress/temp/${fileName}`;
  const CREATE_FILE_WIN = `echo.> cypress\\temp\\${fileName}`;
  cy.get('@isWinSystem').then((isWinSystem) => {
    const script = isWinSystem ? CREATE_FILE_WIN : CREATE_FILE_UNIX;
    cy.exec(script).its('code').should('eq', 0);
  });
});

// ToDo: remove if unused
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
  const DELAY = 3000;
  const RETRIES = 8;

  const CREATE_DOWNLOAD_FOLDER_IF_NOT_EXIST = `mkdir -p ${DOWNLOAD_FOLDER}`;
  cy.exec(CREATE_DOWNLOAD_FOLDER_IF_NOT_EXIST);

  cy.log(`Waiting for ${fileName} file`);
  const iterator = Array.from(Array(RETRIES));
  cy.wrap(false).as('isFilePresent');
  cy.wrap(iterator).each(() => {
    cy.get('@isFilePresent').then((value) => {
      if (value === false) {
        cy.wait(DELAY);
        // replace ls with dir (without -a) for windows for local debugging
        const SHOW_ALL_FILES_IN_DOWNLOAD_FOLDER = `ls -a ${DOWNLOAD_FOLDER}`;
        cy.exec(SHOW_ALL_FILES_IN_DOWNLOAD_FOLDER).then((result) => {
          cy.log(`Command output: ${result.stdout}`);
          if (result.stdout.includes(fileName)) {
            cy.wrap(true).as('isFilePresent');
          }
        });
      }
    });
  });
  
  cy.get('@isFilePresent').then((isFilePresent) => {
    expect(isFilePresent).to.be.equal(true);
  });
});

And('Get full file name with prefix {string} in download folder and save it as {string}', (prefix, alias) => {
  cy.exec(`ls -a ${DOWNLOAD_FOLDER} | grep ${prefix}`).then((output) => {
    expect(output.stdout).to.have.string(prefix);
    cy.log(`Full file name: ${output.stdout}`);
    cy.wrap(output.stdout).as(alias);
  });
});

And('Verify that file {string} from download folder contains text {string}', (fileName, text) => {
  cy.replacePlaceholder(fileName).then((fileNameReplaced) => {
    cy.replacePlaceholder(text).then((expectedText) => {
      cy.exec(`cat ${DOWNLOAD_FOLDER}/${fileNameReplaced}`).then((output) => {
        expect(output.stdout).to.have.string(expectedText);
      });
    });
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
          if (doc.location !== null){
            doc.location.reload();
          }
        }, 5000);
      });
    });
});
