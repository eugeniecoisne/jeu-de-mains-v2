const prevNextNewWs = () => {

  const pNBtn = document.querySelectorAll(".next-previous-button");
  const prevButtons = document.querySelectorAll(".btnPrevious");
  const nextButtons = document.querySelectorAll(".btnNext");
  const cards = document.querySelectorAll(".card");

  if (pNBtn) {

    if (prevButtons) {
      prevButtons.forEach(function(prevbtn) {

        prevbtn.addEventListener("click", (event) => {
          event.preventDefault();

          const index = prevbtn.id[9];
          console.log(index);
          const prevIndex = parseInt(index) - 1;
          console.log(prevIndex);

          const headerCardOpen = document.querySelector(".card-header-" + index);
          const headerCardPrev = document.querySelector(".card-header-" + prevIndex);
          const bodyCardOpen = document.querySelector(".collapse-" + index);
          const bodyCardPrev = document.querySelector(".collapse-" + prevIndex);

          headerCardOpen.classList.add("collapsed")
          bodyCardOpen.classList.remove("show")
          headerCardPrev.classList.remove("collapsed")
          bodyCardPrev.classList.add("show")
        });
      });
    }

    if (nextButtons) {
      nextButtons.forEach(function(nextbtn) {

        nextbtn.addEventListener("click", (event) => {
          event.preventDefault();

          const index = nextbtn.id[5];
          console.log(index);
          const nextIndex = parseInt(index) + 1;
          console.log(nextIndex);

          const headerCardOpen = document.querySelector(".card-header-" + index);
          const headerCardNext = document.querySelector(".card-header-" + nextIndex);
          const bodyCardOpen = document.querySelector(".collapse-" + index);
          const bodyCardNext = document.querySelector(".collapse-" + nextIndex);

          headerCardOpen.classList.add("collapsed")
          bodyCardOpen.classList.remove("show")
          headerCardNext.classList.remove("collapsed")
          bodyCardNext.classList.add("show")
        });
      });
    }
  }
}

export { prevNextNewWs };
