export default {
  apiEndpoint: process.env.REACT_APP_API_ENDPOINT,
  // apiEndpoint: "https://17kl2drmmc.execute-api.us-east-1.amazonaws.com/dev"
  apiGateway: {
    REGION: "us-east-1",
    URL: "https://iqx8648fl1.execute-api.us-east-1.amazonaws.com/test"
  },
  cognito: {
    REGION: "us-east-1",
    USER_POOL_ID: "us-east-1_HISGpsFVc",
    APP_CLIENT_ID: "24147l7r1u1jo4t7v2scjkkerp",
    IDENTITY_POOL_ID: "us-east-1:65513615-70de-4d96-806c-84e34d24d934"
  }
};
