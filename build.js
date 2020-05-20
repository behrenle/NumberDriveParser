const pegjs = require("pegjs");
const fs = require("fs");

fs.readFile("./grammer.pegjs", "utf8", (err, data) => {
  if (err)
    throw err;

  let parser = pegjs.generate(data, { output: "source" });
  fs.writeFile("./parser.js", parser, (err) => {
    if (err)
      throw err;
  });
});
