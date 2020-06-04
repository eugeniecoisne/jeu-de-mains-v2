require("@rails/ujs").start()
require("@rails/activestorage").start()
require("turbolinks").start()
require("channels")

import "bootstrap";
import { initMenu } from '../plugins/init_menu';

document.addEventListener('turbolinks:load', () => {
  initMenu();
});
