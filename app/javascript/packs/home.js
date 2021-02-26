require("@rails/ujs").start()
require("@rails/activestorage").start()
require("turbolinks").start()

import "bootstrap";
import "../plugins/flatpickr";
import { French } from "flatpickr/dist/l10n/fr.js";
import { initMenu } from '../plugins/init_menu';
import { submitTrendSelection } from '../plugins/submit_trend_selection';


document.addEventListener('turbolinks:load', () => {
  flatpickr(".datepicker", {
    "locale": French,
    altInput: true,
  });
  setTimeout(function() {
    $('.alert').fadeOut();
  }, 10000);
  initMenu();
  submitTrendSelection();
});
