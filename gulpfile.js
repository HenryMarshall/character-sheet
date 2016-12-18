const gulp = require("gulp")
const sourcemaps = require("gulp-sourcemaps")
const autoprefixer = require("gulp-autoprefixer")
const sass = require("gulp-sass")
const elm = require("gulp-elm")
const plumber = require("gulp-plumber")
// const livereload = require("gulp-livereload")

gulp.task("sass", function() {
  return gulp.src("src/sass/style.+(sass|scss)")
    .pipe(sourcemaps.init())
    .pipe(sass().on("error", sass.logError))
    .pipe(autoprefixer({ browsers: ["> 1%"] }))
    .pipe(sourcemaps.write("."))
    .pipe(gulp.dest("build"))
    // .pipe(livereload())
})

gulp.task("elm", function() {
  return gulp.src("src/Main.elm")
    .pipe(plumber())
    .pipe(elm.bundle("script.js"))
    .pipe(gulp.dest("build"))
})

gulp.task("build", ["sass", "elm"])

gulp.task("watch", function() {
  gulp.watch("src/sass/**/*.+(sass|scss)", ["sass"])
  gulp.watch("src/**/*.elm", ["elm"])
  // livereload.listen()
})

gulp.task("default", ["build", "watch"])

