var height_changed = function(){
  var container = document.querySelector("div.container");
  var height = Math.max( container.scrollHeight, container.offsetHeight );
  window.parent.postMessage(height, "*"); 
}
