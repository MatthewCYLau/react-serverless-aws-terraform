// Load the AWS SDK for Node.js
const AWS = require("aws-sdk");

// Set the region
AWS.config.update({ region: "us-east-1" });

// Create DynamoDB service object
const ddb = new AWS.DynamoDB({ apiVersion: "2012-08-10" });

exports.handler = (event, context, callback) => {
  // if query parameter commentId is provided
  // query likes by commentId
  // else, scan for all likes
  if (event.queryStringParameters) {
    const commentId = event.queryStringParameters.commentId;
    let responseCode = 200;
    let responseBody = "";

    const params = {
      ExpressionAttributeValues: {
        ":v1": {
          S: commentId
        }
      },
      KeyConditionExpression: "commentId = :v1",
      IndexName: "commentIdIndex",
      TableName: "likes"
    };
    ddb.query(params, function(err, data) {
      if (err) {
        responseCode = 500;
        responseBody = err;
      } else {
        if (data.Items) {
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
  } else {
    let responseCode = 200;
    let responseBody = "";
    const params = {
      TableName: "likes"
    };

    ddb.scan(params, function(err, data) {
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
  }
};
