let slider = document.getElementById('test-slider');

noUiSlider.create(slider, {
  start: [0, 100],
  connect: true,
  step: 1,
  orientation: 'horizontal', // 'horizontal' or 'vertical'
  range: {
    'min': 0,
    'max': 255
  },
  format: wNumb({
    decimals: 0
  }),
  pips: {
    mode: 'range',
    stepped: true,
    density: 100
}
});

slider.noUiSlider.on('change.one', function(e) {
  console.log("Slider has changed");
  segmentateImage(img_luma, img_segmentated, {start: e[0], end: e[1]});
})