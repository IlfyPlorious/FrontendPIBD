const menuBtn = document.getElementById('mobileMenuIcon')
      nav = document.getElementById('linksContainerMobile')
      menuBtnExit = document.getElementById('mobileXIcon');

menuBtn.addEventListener('click', () => {
    nav.classList.add("active");
})

menuBtnExit.addEventListener('click', () => {
    nav.classList.remove("active");
})