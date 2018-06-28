window.onload = () =>{
  let specieFields = document.querySelector(".specie-fields");
  let specieSelect = document.querySelector(".select-specie");
  const specieToggle = document.querySelector("#toggleSpecie");
  specieToggle.addEventListener("change", (e) => {
    const check = e.target;
    specieFields.style.display = (e.target.checked) ? "block" : "none";
    specieSelect.style.display = (e.target.checked) ? "none" : "block";
  });
}
