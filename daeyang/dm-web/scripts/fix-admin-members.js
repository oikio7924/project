const fs = require("fs");
const path = require("path");

function clean(html) {
  return html.replace(/<\/?motion\b[^>]*>/gi, function (t) {
    return t.replace(/motion/gi, "motion");
  }).replace(/motion/gi, "div");
}

const src = fs.readFileSync(path.join(__dirname, "write-admin-html.js"), "utf8");
const m = src.match(/const members = `([\s\S]*?)`;/);
if (!m) {
  console.error("members template not found");
  process.exit(1);
}

const pub = path.join(__dirname, "..", "public");
fs.writeFileSync(path.join(pub, "admin-members.html"), clean(m[1]), "utf8");
console.log("admin-members.html written (utf8)");
