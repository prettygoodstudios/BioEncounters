let toggleButton = document.querySelector("#toggle");
let menu = document.querySelector(".menu");
let profileMenu = document.querySelector(".menu-profile");
let profileItems = document.querySelector(".menu-profile-items");
let lastWidth = window.innerWidth;
let touchStartX = 0;
let touchStartY = 0;

const toggleMenu = () => {
  console.log("Toggling");
  menu.classList.toggle("menu__hide");
  menu.classList.toggle("menu__show");
  toggleButton.classList.toggle("toggle__open");
  toggleButton.classList.toggle("toggle__closed");
  if(menu.style.display == "none") profileItems.classList.remove("menu-profile-items-hover");
}

toggleButton.addEventListener("click", toggleMenu);
if(document.querySelectorAll(".menu-profile").length != 0){
  profileMenu.addEventListener("click",function(){
    if(window.innerWidth <= 500) profileItems.classList.toggle("menu-profile-items-hover");
    if(window.innerWidth <= 500) profileMenu.classList.toggle("menu-profile-header-hover");
  });
}

document.addEventListener("touchstart", ({touches}) => {
  const {clientX, clientY} = touches[0];
  touchStartX = clientX;
  touchStartY = clientY;
});

document.addEventListener("touchend", ({changedTouches}) => {
  const {clientX, clientY} = changedTouches[0];
  const shouldToggle = (menu.className.indexOf("menu__show") == -1) ? (clientX - touchStartX > 50 && touchStartX < 100 && Math.abs(clientY - touchStartY) < 100) : (touchStartX - clientX > 50 && touchStartX < document.querySelector(".menu__show").clientWidth);
  if(shouldToggle) toggleMenu();
  touchStartX = 0;
  touchStartY = 0;
});
