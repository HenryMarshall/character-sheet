const gulp = require("gulp")
const sourcemaps = require("gulp-sourcemaps")
const autoprefixer = require("gulp-autoprefixer")
const sass = require("gulp-sass")
const livereload = require("gulp-livereload")

gulp.task("sass", function() {
  return gulp.src("src/sass/style.+(sass|scss)")
    .pipe(sourcemaps.init())
    .pipe(sass().on("error", sass.logError))
    .pipe(autoprefixer({ browsers: ["> 1%"] }))
    .pipe(sourcemaps.write("."))
    .pipe(gulp.dest("build/style"))
    // .pipe(livereload())
})

gulp.task("build", ["sass"])

gulp.task("watch", function() {
  gulp.watch("src/sass/**/*.+(sass|scss)", ["sass"])
  // livereload.listen()
})

gulp.task("default", ["build", "watch"])

