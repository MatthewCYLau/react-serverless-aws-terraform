// Load the AWS SDK for Node.js
const AWS = require("aws-sdk");

// Set the region
AWS.config.update({ region: "us-east-1" });

// Create DynamoDB service object
const ddb = new AWS.DynamoDB({ apiVersion: "2012-08-10" });

exports.handler = function(event, context, callback) {
  let responseCode = 200;
  let responseBody = "";
  const params = {
    TableName: "comments",
    Item: {
      commentId: { S: event.requestContext.requestId },
      identityId: { S: event.requestContext.identity.cognitoIdentityId },
      username: { S: JSON.parse(event.body).username },
      content: { S: JSON.parse(event.body).content },
      todoId: { S: JSON.parse(event.body).todoId }
    }
  };

  // Call DynamoDB to add the item to the table
  ddb.putItem(params, function(err, data) {
    if (err) {
      console.log("Error", err);
      responseCode = 500;
      responseBody = err;
    } else {
      console.log("Success", data);
      responseBody = data;
    }
    const response = {
      statusCode: responseCode,
      headers: {
        "content-type": "application/json",
        "Access-Control-Allow-Origin": "*"
      },
      body: JSON.stringify(responseBody)
    };
    callback(null, response);
  });
};
