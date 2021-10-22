require("@rails/ujs").start()
require("@rails/activestorage").start()
require("turbolinks").start()
require("channels")

import "bootstrap";
import "../plugins/flatpickr";
import { French } from "flatpickr/dist/l10n/fr.js";
import { initMenu } from '../plugins/init_menu';
import { initPlaces } from '../plugins/init_places';
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
import { submitBookingOptions } from '../plugins/submit_booking_options';
import { submitTrendSelection } from '../plugins/submit_trend_selection';
import { initChatroomCable } from '../channels/chatroom_channel';


document.addEventListener('turbolinks:load', () => {
  flatpickr(".datepicker", {
    "locale": French,
    altInput: true,
  }); // calendars in searches and sessions create
  setTimeout(function() {
    $('.alert').fadeOut();
  }, 10000); // alerts (notices and alerts) disappear after 10 seconds
  initMenu(); // menu burger and side menu in shared#navbar
  initPlaces(); // Tickets available when booking in workshops#show
  initMapbox(); // Init Mapbox in workshops#index
  initFullMap(); // Toggle between map and list in mobile view of workshops#index
  showMoreWs(); // Show more or less workshops in profiles#public
  initRating(); // Dynamical rating in reviews#new
  showActions(); // Dashboard my workshops button to manage a ws and show actions in profiles#_dashboard_organizer
  toggleBtnKpis(); // Toggle KPIS in profiles#_dashboard_organizer
  prevNextNewWs(); // Prev and Next btns in workshops#new and workshops#finalization
  showInfomessageBox(); // Show infomessage text editor to send email in sessions#participants
  showIndexFilters(); // shows filters in profiles#index
  showGiftcardOptions(); // when using a giftcard in booking#options
  submitBookingOptions(); // when booking workshop in bookings#options
  submitTrendSelection(); // go to trends search from pages#home
  initChatroomCable(); // messages with chatroom and message
});
