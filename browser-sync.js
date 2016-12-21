module.exports = {
  files: ["build/*.(html|css|js)"],
  server: {
    baseDir: "build",
    middleware: [
      require("connect-history-api-fallback")(),
    ],
  },
}
