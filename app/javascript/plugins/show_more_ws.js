const showMoreWs = () => {
  const moreButton = document.querySelector("#showMoreWsButton");
  const moreDiv = document.querySelector(".show-more-workshops");
  const lessButton = document.querySelector("#showLessWsButton");
  const lessDiv = document.querySelector(".show-less-workshops");
  const workshopsDiv = document.querySelector(".public-profile-our-ws-cards");

  if (moreButton) {
    moreButton.addEventListener("click", (event) => {
      event.preventDefault();
      moreDiv.classList.remove("active")
      lessDiv.classList.add("active")
      workshopsDiv.classList.add("long")
    });
  }
  if (lessButton) {
    lessButton.addEventListener("click", (event) => {
      event.preventDefault();
      lessDiv.classList.remove("active")
      moreDiv.classList.add("active")
      workshopsDiv.classList.remove("long")
    });
  }
}

export { showMoreWs };
