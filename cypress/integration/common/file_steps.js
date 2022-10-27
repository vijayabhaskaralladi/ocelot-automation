import { And } from 'cypress-cucumber-preprocessor/steps';

const DOWNLOAD_FOLDER = Cypress.config('downloadsFolder');

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
      cy.exec(`cat "${DOWNLOAD_FOLDER}/${fileNameReplaced}"`).then((output) => {
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
