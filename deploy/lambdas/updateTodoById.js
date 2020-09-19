// Load the AWS SDK for Node.js
const AWS = require("aws-sdk");

// Set the region
AWS.config.update({ region: "us-east-1" });

// Create DynamoDB service object
const ddb = new AWS.DynamoDB({ apiVersion: "2012-08-10" });

exports.handler = (event, context, callback) => {
  const todoId = event.path.split("/")[2];
  let responseCode = 200;
  let responseBody = "";

  const params = {
    ExpressionAttributeNames: {
      "#N": "name",
      "#D": "description"
    },
    ExpressionAttributeValues: {
      ":n": {
        S: JSON.parse(event.body).name
      },
      ":d": {
        S: JSON.parse(event.body).description
      }
    },
    Key: {
      todoId: {
        S: todoId
      }
    },
    ReturnValues: "ALL_NEW",
    TableName: "todos",
    UpdateExpression: "SET #N = :n, #D = :d"
  };
  ddb.updateItem(params, function(err, data) {
    if (err) {
      responseCode = 500;
      responseBody = err;
    } else {
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
