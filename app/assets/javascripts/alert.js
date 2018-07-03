window.addEventListener("load", () => {
  handleAlert(false);
});
window.onbeforeunload = () => {
  handleAlert(true);
}
let fired = false;
function handleAlert(before){
  const alertContent = document.querySelector(".alert__content");
  let alert = document.querySelector(".alert");
  const alertDismiss = document.querySelector(".alert__dismiss");
  alert.style.display = (alertContent.innerHTML.trim() == "" || ((window.location == `${ROOT_URL}` || fired) && before)) ? "none" : "block";
  if(alertDismiss != undefined){
    alertDismiss.addEventListener("click", () => {
      alert.style.display = "none";
    });
  }
  fired = true;
}
