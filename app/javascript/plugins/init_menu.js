const initMenu = () => {
  const menuButton = document.querySelector("#menuButton");
  const menu = document.querySelector("#sideMenu");
  const menuClose = document.querySelector("#menuClose");

  if (menuButton) {
    menuButton.addEventListener("click", (event) => {
      event.preventDefault();
      menu.classList.add("open");
    });
  }
  if (menuClose) {
    menuClose.addEventListener("click", (event) => {
      event.preventDefault();
      menu.classList.remove("open");
    });
  }
}

export { initMenu };
