import "@stimulus/polyfills" // required for IE11 support
import { Application } from "stimulus"

// a rollup plugin to help us load controllers without webpack
import controllers from "stimulus-controllers"

const application = Application.start()
application.load(controllers)
