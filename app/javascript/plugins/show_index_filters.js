const showIndexFilters = () => {
  const showFiltersButton = document.querySelector("#showIndexFilters");
  const hideFiltersButton = document.querySelector("#hideIndexFilters");
  const filtersButtonDiv = document.querySelector(".place-animator-index-filter");
  const filtersDiv = document.querySelector(".place-animator-index-search");

  if (showFiltersButton) {
    showFiltersButton.addEventListener("click", (event) => {
      event.preventDefault();
      filtersDiv.classList.add("active")
      filtersButtonDiv.classList.add("inactive")
      hideFiltersButton.classList.add("active")
    });
  }

  if (hideFiltersButton) {
    hideFiltersButton.addEventListener("click", (event) => {
      event.preventDefault();
      filtersDiv.classList.remove("active")
      filtersButtonDiv.classList.remove("inactive")
    });
  }
}

export { showIndexFilters };

