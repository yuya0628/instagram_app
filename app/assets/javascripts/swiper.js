// ここがポイント！！！！
// アセットパイプラインにおけるJSについてはES6記法であるrequireは使えません。
// また、DOMの読み込みを待ってあげる必要があるので $(functionで囲いましょう。
 $(function() {
  var mySwiper = new Swiper('.swiper-container', {
    // Optional parameters
    direction: 'horizontal',
    loop: true,

    // If we need pagination
    pagination: {
      el: '.swiper-pagination',
    },

    // Navigation arrows
    navigation: {
      nextEl: '.swiper-button-next',
      prevEl: '.swiper-button-prev',
    },

    // And if we need scrollbar
    scrollbar: {
      el: '.swiper-scrollbar',
    },
  })  
 })