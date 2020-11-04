const showInfomessageBox = () => {
  const button = document.querySelector("#contactParticipantsBtn");
  const box = document.querySelector(".infomessage-box");

  if (button) {
    button.addEventListener("click", (event) => {
      event.preventDefault();
      box.classList.remove("inactive")
      box.classList.add("active")
      button.classList.remove("active")
      button.classList.add("inactive")
    });
  }
}

export { showInfomessageBox };
