const toggleBtnKpis = () => {
  const toggleBtnBookings = document.querySelector("#togBtnBookings");
  const sevenBookings = document.querySelector(".my-bookings-seven-days");
  const thirtyBookings = document.querySelector(".my-bookings-thirty-days");
  const toggleBtnCancellations = document.querySelector("#togBtnCancellations");
  const sevenCancellations = document.querySelector(".my-cancellations-seven-days");
  const thirtyCancellations = document.querySelector(".my-cancellations-thirty-days");

  if (toggleBtnBookings) {
    toggleBtnBookings.addEventListener("change", (event) => {
      event.preventDefault();
      sevenBookings.classList.toggle("active")
      thirtyBookings.classList.toggle("active")
    });
  }
  if (toggleBtnCancellations) {
    toggleBtnCancellations.addEventListener("change", (event) => {
      event.preventDefault();
      sevenCancellations.classList.toggle("active")
      thirtyCancellations.classList.toggle("active")
    });
  }
}

export { toggleBtnKpis };
