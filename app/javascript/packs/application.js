require("@rails/ujs").start()
require("@rails/activestorage").start()
require("turbolinks").start()
require("channels")

import "bootstrap";
import { initMenu } from '../plugins/init_menu';
import { initPlaces } from '../plugins/init_places';
import { initBooking } from '../plugins/init_booking';

document.addEventListener('turbolinks:load', () => {
  initMenu();
  initPlaces();
  initBooking();
});
