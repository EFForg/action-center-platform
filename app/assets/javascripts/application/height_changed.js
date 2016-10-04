var height_changed = function(){
  // If using scroll effect, adjust the window height so the sidebar fits.
  if (window.scroller) window.scroller();

  // For embeds, notify the parent window so it can resize the iframe.
  var container = document.querySelector("div.container");
  var height = Math.max( container.scrollHeight, container.offsetHeight );
  window.parent.postMessage(height, "*");
}
