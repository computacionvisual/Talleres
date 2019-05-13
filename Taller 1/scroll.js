let sectionIndex = 0;
let sectionList = document.getElementsByTagName('section');

window.addEventListener('wheel', _.throttle(function(event){
  if(event.deltaY < 0) {
    // Scroll up
    if(sectionIndex - 1 < 0) return;
    sectionList[--sectionIndex].scrollIntoView({ block: 'end', behavior: 'smooth' });
  } else {
    // Scroll down 
    if(sectionIndex + 1 >= sectionList.length) return;
    sectionList[++sectionIndex].scrollIntoView({ block: 'end', behavior: 'smooth' });
  }

}, 250)) 