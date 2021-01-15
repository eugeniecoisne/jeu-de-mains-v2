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
import { initMapbox } from '../plugins/init_mapbox';
import { initFullMap } from '../plugins/init_fullmap';
import { showMoreWs } from '../plugins/show_more_ws';
import { initRating } from '../plugins/init_rating';
import { showActions } from '../plugins/show_actions';
import { toggleBtnKpis } from '../plugins/toggle_btn_kpis';
import { prevNextNewWs } from '../plugins/prev_next_new_ws';
import { showInfomessageBox } from '../plugins/show_infomessage_box';
import { showIndexFilters } from '../plugins/show_index_filters';
import { showGiftcardOptions } from '../plugins/show_giftcard_options';
import { initChatroomCable } from '../channels/chatroom_channel';


document.addEventListener('turbolinks:load', () => {
  flatpickr(".datepicker", {
    "locale": French,
    altInput: true,
  });
  initMenu();
  initPlaces();
  initMapbox();
  initFullMap();
  initBooking();
  showMoreWs();
  initRating();
  showActions();
  toggleBtnKpis();
  prevNextNewWs();
  showInfomessageBox();
  showIndexFilters();
  showGiftcardOptions();
  initChatroomCable();
});
