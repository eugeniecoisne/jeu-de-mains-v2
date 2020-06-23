const initFullMap = () => {
  const mapButton = document.querySelector("#mapButton");
  const listButton = document.querySelector("#listButton");
  const map = document.querySelector("#map");
  const container = document.querySelector(".index-ws-cards-map-container");

  mapButton.addEventListener("click", (event) => {
    event.preventDefault();
    map.classList.add("active");
    container.classList.add("fullmap");
    mapButton.classList.add("inactive");
    listButton.classList.remove("inactive");
  });

  listButton.addEventListener("click", (event) => {
    event.preventDefault();
    map.classList.remove("active");
    container.classList.remove("fullmap");
    mapButton.classList.remove("inactive");
    listButton.classList.add("inactive");
  });
}

export { initFullMap };
