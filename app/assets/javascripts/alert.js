window.onload = () => {
  handleAlert();
}
window.onbeforeunload = () => {
  handleAlert();
}
function handleAlert(){
  const alertContent = document.querySelector(".alert__content");
  let alert = document.querySelector(".alert");
  const alertDismiss = document.querySelector(".alert__dismiss");
  alert.style.display = (alertContent.innerHTML.trim() == "") ? "none" : "block";
  if(alertDismiss != undefined){
    alertDismiss.addEventListener("click", () => {
      alert.style.display = "none";
    });
  }
}
