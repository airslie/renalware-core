//
// Entry point for the build script in package.json
//

import "@stimulus/polyfills" // required for IE11 support
import "promise-polyfill/src/polyfill"
import "whatwg-fetch"
import "./controllers"
import { Turbo } from "@hotwired/turbo-rails"

Turbo.session.drive = false // By default disable Turbo on all pages
