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
    Key: {
      todoId: {
        S: todoId
      }
    },
    TableName: "todos"
  };
  ddb.getItem(params, function(err, data) {
    if (err) {
      responseCode = 500;
      responseBody = err;
    } else {
      if (data.Item) {
        responseBody = data;
      } else {
        responseCode = 404;
        responseBody = "Data not found";
      }
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
