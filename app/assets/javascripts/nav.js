let toggleButton = document.querySelector("#toggle");
let menu = document.querySelector(".menu");
let profileMenu = document.querySelector(".menu-profile");
let profileItems = document.querySelector(".menu-profile-items");
let lastWidth = window.innerWidth;
toggleButton.addEventListener("click",function(){
  menu.classList.toggle("menu__hide");
  menu.classList.toggle("menu__show");
  toggleButton.classList.toggle("toggle__open");
  toggleButton.classList.toggle("toggle__closed");
  if(menu.style.display == "none") profileItems.classList.remove("menu-profile-items-hover");
});
if(document.querySelectorAll(".menu-profile").length != 0){
  profileMenu.addEventListener("click",function(){
    if(window.innerWidth <= 500) profileItems.classList.toggle("menu-profile-items-hover");
  });
}
