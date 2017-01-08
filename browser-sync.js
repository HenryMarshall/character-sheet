module.exports = {
  files: ["build/*.(css|js)", "index.html"],
  server: {
    baseDir: ".",
    middleware: [
      require("connect-history-api-fallback")(),
    ],
  },
}
