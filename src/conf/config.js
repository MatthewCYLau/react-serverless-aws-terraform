export default {
  apiGateway: {
    REGION: "us-east-1",
    URL: process.env.REACT_APP_API_ENDPOINT
  },
  cognito: {
    REGION: "us-east-1",
    USER_POOL_ID: process.env.USER_POOL_ID,
    APP_CLIENT_ID: process.env.APP_CLIENT_ID,
    IDENTITY_POOL_ID: process.env.IDENTITY_POOL_ID
  }
};
