const showActions = () => {

  const actionButtons = document.querySelectorAll(".show-actions-button");
  const actionsDivs = document.querySelectorAll(".ws-dashboard-organizer-buttons")

  if (actionButtons) {

    actionButtons.forEach(function(actionbtn) {

      actionbtn.addEventListener("click", (event) => {
        event.preventDefault();

        const index = actionbtn.id.slice(-1);
        console.log(index);

        const actionsDiv = document.querySelector("#ws-dashboard-organizer-buttons-" + index);
        const actionButton = document.querySelector(".show-actions-button-" + index);


        actionbtn.classList.remove("active")
        actionsDiv.classList.add("active")
      });
    });
  }
}

export { showActions };
