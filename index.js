const request = require("request");
const { spawn } = require('child_process');


console.log("Spawning app...");
const app = spawn("./app");
let appReady = false;
const queue = [];

app.stdout.on("data", (data) => {
    const string = data.toString("utf8");
    console.log(`stdout: ${string}`);
    if (string.indexOf("Your Web application is running") > -1) {
        appReady = true;
        for (let params of queue) {
            makeRequest(params.event, params.callback);
        }
        delete queue;
    }
});

app.stderr.on("data", (data) => {
    console.log(`stderr: ${data}`);
});

app.on("close", (code) => {
    console.log(`child process exited with code ${code}`);
});

const makeRequest = (event, callback) => {
    request({
        uri: "http://localhost:8080",
        method: "POST",
        json: event,
    }, (err, res, body) => {
        callback(err, body);
    });
};

const handler = (event, context, callback) => {
    context.callbackWaitsForEmptyEventLoop = false;

    if (appReady) {
        makeRequest(event, callback);
    } else {
        queue.push({event, callback});
    }
};

exports.handler = handler;

