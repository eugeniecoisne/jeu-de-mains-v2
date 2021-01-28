const submitTrendSelection = () => {
  const trendOneDiv = document.querySelector("#home-selection-first");
  const trendTwoDiv = document.querySelector("#home-selection-second");
  const trendOneForm = document.querySelector(".selected-ws-1");
  const trendTwoForm = document.querySelector(".selected-ws-2");

  if (trendOneDiv) {
    trendOneDiv.addEventListener("click", (event) => {
      event.preventDefault();
      trendOneForm.submit();
    });
  }
  if (trendTwoDiv) {
    trendTwoDiv.addEventListener("click", (event) => {
      event.preventDefault();
      trendTwoForm.submit();
    });
  }
}

export { submitTrendSelection };
