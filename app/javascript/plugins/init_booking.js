const initBooking = () => {
  const bookingButton = document.querySelector("#bookingButton");
  const bookingBox = document.querySelector("#bookingBox");
  const informationBox = document.querySelector("#hideShowInformation");
  const bookingClose = document.querySelector("#bookingExit");

  bookingButton.addEventListener("click", (event) => {
    event.preventDefault();
    bookingBox.classList.add("active");
    bookingClose.classList.add("active");
    informationBox.classList.add("inactive");
    bookingButton.classList.add("inactive");
  });

  bookingClose.addEventListener("click", (event) => {
    event.preventDefault();
    bookingBox.classList.remove("active");
    bookingClose.classList.remove("active");
    informationBox.classList.remove("inactive");
    bookingButton.classList.remove("inactive");
  });
}

export { initBooking };
