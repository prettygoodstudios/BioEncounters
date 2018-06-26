let toggleButton = document.querySelector("#toggle");
let menu = document.querySelector(".menu");
let profileMenu = document.querySelector(".menu-profile");
let profileItems = document.querySelector(".menu-profile-items");
let lastWidth = window.innerWidth;
toggleButton.addEventListener("click",function(){
  menu.style.display = (menu.style.display == "flex") ? "none" : "flex";
  toggleButton.innerHTML = (menu.style.display == "none") ? "Menu" : "Close";
  if(menu.style.display == "none") profileItems.classList.remove("menu-profile-items-hover");
});
if(document.querySelectorAll(".menu-profile").length != 0){
  profileMenu.addEventListener("click",function(){
    if(window.innerWidth <= 500) profileItems.classList.toggle("menu-profile-items-hover");
  });
}
window.onresize = function(){
  if(window.innerWidth >= 500){
    menu.style.display = "flex";
    toggleButton.innerHTML = "Menu";
    if(document.querySelectorAll(".menu-profile").length != 0) profileItems.classList.remove("menu-profile-items-hover");
  }else if(lastWidth >= 500){
    menu.style.display = "none";
  }
  lastWidth = window.innerWidth;
}
