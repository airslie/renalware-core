import "../../assets/stylesheets/tailwind/tailwind.css"

import "@stimulus/polyfills" // required for IE11 support
import { Application } from "stimulus"

// Manually import stimulusjs controllers for now as we had problems with the stimulus-controllers
// package on CI ('file.isDirectory is not a function')
// and cannot use the webpacker-helper/require method as per usual in a rails app as we
// do not use webpacker in this engine because it is a poor fit. We just want to compile all
// es6 assets into a file in app/assets/javascripts so that they can be used in the asset pipeline
// by a host app initially. We could publish our package to e.g. GH packages at some point in the
// future so that a host app can include us using webpacker and skip the asset pipeline, but we
// are a little way off that.
// So the approach right now is quite simple - to allow is to use stimulus.js and IE11
// (via the polyfill) for new js development, and the remaining js can be ported or moved at some
// point in the future.
// The rollupjs setup from adapted from the approach used by ActiveStorage
import ToggleController from "./controllers/toggle_controller"
import HDPrescriptionController from "./controllers/hd/prescription_administration_controller"
import MedicationsHomeDeliveryModalController from "./controllers/medications/home_delivery_modal_controller"
import SnippetsController from "./controllers/snippets_controller"
import LettersFormController from "./controllers/letters/form_controller"
import PrescriptionsController from "./controllers/medications/prescriptions_controller"
import ChartsController from "./controllers/charts_controller"
import SessionController from "./controllers/session_controller"
import SimpleToggleController from "./controllers/simple_toggle_controller"
import TabsController from "./controllers/tabs_controller"
import PDPetChartsController from "./controllers/pd/pet_charts_controller"
import PathologySparklinesController from "./controllers/pathology/sparklines_controller"
import CollapsibleController from "./controllers/collapsible_controller"
import PatientAttachmentsController from "./controllers/patients/attachments_controller"

const application = Application.start()
application.register("toggle", ToggleController)
application.register("hd-prescription-administration", HDPrescriptionController)
application.register("home-delivery-modal", MedicationsHomeDeliveryModalController)
application.register("snippets", SnippetsController)
application.register("letters-form", LettersFormController)
application.register("prescriptions", PrescriptionsController)
application.register("charts", ChartsController)
application.register("session", SessionController)
application.register("simple-toggle", SimpleToggleController)
application.register("tabs", TabsController)
application.register("pd-pet-chart", PDPetChartsController)
application.register("pathology-sparklines", PathologySparklinesController)
application.register("collapsible", CollapsibleController)
application.register("patient-attachments", PatientAttachmentsController)

window.Chartkick.use(window.Highcharts)
