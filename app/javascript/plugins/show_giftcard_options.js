const showGiftcardOptions = () => {
  const showGiftcardOptionsBtn = document.querySelector("#showGiftcardOptions");
  const giftcardOptionsDiv = document.querySelector(".booking-options-giftcard-options");

  if (showGiftcardOptionsBtn) {
    showGiftcardOptionsBtn.addEventListener("click", (event) => {
      event.preventDefault();
      giftcardOptionsDiv.classList.toggle("inactive");
      showGiftcardOptionsBtn.classList.toggle("inactive");
    });
  }
}

export { showGiftcardOptions };

