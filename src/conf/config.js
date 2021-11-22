export default {
  apiGateway: {
    REGION: "us-east-1",
    URL: process.env.REACT_APP_API_ENDPOINT
  },
  cognito: {
    REGION: "us-east-1",
    USER_POOL_ID: process.env.REACT_APP_USER_POOL_ID,
    APP_CLIENT_ID: process.env.REACT_APP_APP_CLIENT_ID,
    IDENTITY_POOL_ID: process.env.REACT_APP_IDENTITY_POOL_ID
  }
};
