const index = require("../index");

index.handler({data: "Hello world!"}, {}, (err, data) => {
    if (err) {
        console.log("Error!");
        console.log(err);
    } else {
        console.log("Success!");
        if (data) {
            console.log(data);
        }
    }
});

