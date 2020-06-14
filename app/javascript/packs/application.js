require("@rails/ujs").start()
require("@rails/activestorage").start()
require("turbolinks").start()
require("channels")

import "bootstrap";
import "../plugins/flatpickr";
import { French } from "flatpickr/dist/l10n/fr.js";
import { initMenu } from '../plugins/init_menu';
import { initPlaces } from '../plugins/init_places';
import { initBooking } from '../plugins/init_booking';

document.addEventListener('turbolinks:load', () => {
  flatpickr(".datepicker", {
    "locale": French,
    altInput: true,
  });
  initMenu();
  initPlaces();
  initBooking();
});
