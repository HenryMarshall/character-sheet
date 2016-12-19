const gulp = require("gulp")
const sourcemaps = require("gulp-sourcemaps")
const autoprefixer = require("gulp-autoprefixer")
const sass = require("gulp-sass")
const elm = require("gulp-elm")
const browserSync = require("browser-sync")
const reload = browserSync.reload
const plumber = require("gulp-plumber")

gulp.task("browser-sync", function() {
  browserSync({
    server: ".",
  })
})

gulp.task("sass", function() {
  return gulp.src("src/sass/style.+(sass|scss)")
    .pipe(sourcemaps.init())
    .pipe(sass().on("error", sass.logError))
    .pipe(autoprefixer({ browsers: ["> 1%"] }))
    .pipe(sourcemaps.write("."))
    .pipe(gulp.dest("build"))
    .pipe(reload({ stream: true }))
})

gulp.task("elm", function() {
  return gulp.src("src/Main.elm")
    .pipe(plumber(errorHandler))
    .pipe(elm.bundle("script.js"))
    .pipe(gulp.dest("build"))
    .pipe(reload({ stream: true }))
})

gulp.task("build", ["sass", "elm", "browser-sync"])

gulp.task("watch", function() {
  gulp.watch("src/sass/**/*.+(sass|scss)", ["sass"])
  gulp.watch("src/**/*.elm", ["elm"])
})

gulp.task("default", ["build", "watch"])

function errorHandler(err) {
  browserSync.notify(err.message)
  console.log(err)
  this.emit("end")
}

