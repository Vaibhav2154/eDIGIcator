// Initialize Google Translate
const translate = new Translate({
    projectId: process.env.GOOGLE_CLOUD_PROJECT_ID,
    keyFilename: 'PATH_TO_SERVICE_ACCOUNT.json',
  });
  