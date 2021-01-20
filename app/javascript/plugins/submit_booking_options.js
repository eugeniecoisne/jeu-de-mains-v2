const submitBookingOptions = () => {
  const bookingOptionsPage = document.querySelector(".booking-options-container")

  if (bookingOptionsPage) {

    const input = document.querySelector('input[type=checkbox]');
    const booking_update_form = document.querySelector(".edit_contact_cgv_booking");

    if (input) {
      input.addEventListener("change", (event) => {
        event.preventDefault();
        booking_update_form.submit();
      });
    }

    const giftcardForm = document.querySelector(".edit_giftcard_booking");

    if (giftcardForm) {
      giftcardForm.addEventListener("change", (event) => {
        event.preventDefault();
        giftcardForm.submit();
      });
    }

    const button = document.querySelector('.go-to-payment-btn')

    if (button) {
      button.addEventListener("click", (event) => {
        event.preventDefault();
        alert("Vous devez renseigner vos coordonnées demandées et donner votre accord sur les conditions générales de vente de Jeu de Mains pour continuer");
      });
    }
  }
}

export { submitBookingOptions };

