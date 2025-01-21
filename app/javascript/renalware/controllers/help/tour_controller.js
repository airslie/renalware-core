import { Controller } from "@hotwired/stimulus"
import Shepherd from 'shepherd.js';

export default class extends Controller {
  connect() {
    // Not uet implemented!
    // The idea has is we will use some json from the help/xx_controller to initialise
    // and start a new tour.
    // Example code for dashboard page commented out below.
    // const tour = new Shepherd.Tour({
    //   useModalOverlay: true,
    //   defaultStepOptions: {
    //     classes: 'shadow-md bg-purple-dark mt-10',
    //     scrollTo: { behavior: 'smooth', block: 'center' },
    //     exitOnEsc: true
    //   }
    // });

    // tour.addStep({
    //   id: 'letters-step',
    //   title: 'Letters',
    //   text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec a diam lectus. Sed sit amet ipsum mauris.',
    //   attachTo: {
    //     element: 'article.letters',
    //     on: 'bottom-start'
    //   },
    //   buttons: [
    //     {
    //       text: 'Next',
    //       action: tour.next
    //     }
    //   ]
    // });

    // tour.addStep({
    //   id: 'bookmarks-step',
    //   title: 'Bookmarks',
    //   text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec a diam lectus. Sed sit amet ipsum mauris.',
    //   attachTo: {
    //     element: 'article.bookmarks',
    //     on: 'bottom'
    //   },
    //   buttons: [
    //     {
    //       text: 'Next',
    //       action: tour.next
    //     }
    //   ]
    // });

    // tour.start();
  }
}
