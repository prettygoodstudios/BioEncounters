const groups = document.querySelectorAll(".form-group");
groups.forEach((g) => {
  if(g.querySelector("input").value != "") g.className = "form-group__focus";
  const input = g.querySelector("input");
  input.addEventListener("focus", () => {
    g.className = "form-group__focus";
  });
  input.addEventListener("focusout", () => {
    if(input.value == "") g.className = "form-group";
  });
  input.addEventListener("blur", () => {
    console.log("changing");
    checkEachOne();
  });
});
window.onload = () => {
  checkEachOne();
}
function checkEachOne(){
  groups.forEach((g) => {
     console.log(g.querySelector("input").type);
    if(g.querySelector("input").value == "" && (g.querySelector("input").type != "password" || groups[0].querySelector("input").value == "")){
      g.className = "form-group";
    }else{
      g.className = "form-group__focus";
    }
  });
}
