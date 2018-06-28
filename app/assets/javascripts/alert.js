window.onload = () => {
  console.log("Hello");
  const alertContent = document.querySelector(".alert__content");
  let alert = document.querySelector(".alert");
  const alertDismiss = document.querySelector(".alert__dismiss");
  console.log(alertContent);
  alert.style.display = (alertContent.innerHTML.trim() == "") ? "none" : "block";
  if(alertDismiss != undefined){
    alertDismiss.addEventListener("click", () => {
      alert.style.display = "none";
    });
  }
}
