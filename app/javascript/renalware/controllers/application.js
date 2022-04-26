import { Application } from "stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.warnings  = true
application.debug     = false
window.Stimulus       = application

export { application }
