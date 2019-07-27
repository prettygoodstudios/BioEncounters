const groups = document.querySelectorAll(".form-group");
groups.forEach((g) => {
  if(g.querySelector("input").value != "") g.className = "form-group__focus";
  const input = g.querySelector("input");
  input.addEventListener("focusin", () => {
    g.className = "form-group__focus";
  });
  input.addEventListener("focusout", () => {
    if(input.value == "") g.className = "form-group";
  });
  input.addEventListener("blur", () => {
    console.log("changing");
    checkEachOne();
  });
  input.addEventListener("keydown", () => {
    g.className = "form-group__focus";
  });
  input.addEventListener("change", () => {
    g.className = "form-group__focus";
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
