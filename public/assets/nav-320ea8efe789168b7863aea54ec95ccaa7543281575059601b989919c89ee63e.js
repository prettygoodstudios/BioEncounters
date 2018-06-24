let toggleButton = document.querySelector("#toggle");
let menu = document.querySelector(".menu");
let lastWidth = window.innerWidth;
toggleButton.addEventListener("click",function(){
  menu.style.display = (menu.style.display == "none") ? "flex" : "none";
});
window.onresize = function(){
  if(window.innerWidth >= 500){
    menu.style.display = "flex";
  }else if(lastWidth >= 500){
    menu.style.display = "none";
  }
  lastWidth = window.innerWidth;
}
;
