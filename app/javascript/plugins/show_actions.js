const showActions = () => {

  const actionButton = document.querySelector(".show-actions-button");
  const actionsDiv = document.querySelector(".ws-dashboard-organizer-buttons")

  if (actionButton) {
    actionButton.addEventListener("click", (event) => {
      event.preventDefault();
      actionButton.classList.remove("active")
      actionsDiv.classList.add("active")
    });
  }
}

export { showActions };
