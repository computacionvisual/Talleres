let canvas;
let img_base;
let img_filter;

const R = 0, G = 1, B = 2;
const HISTOGRAM_HEIGHT = 230;
const HISTOGRAM_POSITION = 600;
let image_source = './images/Landscape.jpg';

function preload() {

  img_base = loadImage(image_source);
  img_filter = loadImage(image_source);
}

function setup() {
  canvas = createCanvas(window.innerWidth, window.innerHeight);
  canvas.parent('canvas');

  // applyMask(img_base, MASK_SHARPEN);
}

function draw() {
  let aspectRatio = img_base.width / img_base.height;
  let imageSize = 700;
  image(img_base, 50, 50, imageSize, imageSize / aspectRatio);
  image(img_filter, 60 + imageSize, 50, imageSize, imageSize / aspectRatio);
}

// Extra functions

// GRAYSCALE

function lumaGrayscale(image) {
  let R = 0, G = 1, B = 2;
  image.loadPixels();

  for (let i = 0; i < image.width; i++) {
    for (let j = 0; j < image.height; j++) {
      let pixel = image.get(i, j);
      let lumaValue = (0.2126 * pixel[R]) + (0.7152 * pixel[G]) + (0.0722 * pixel[B])

      image.set(i, j, color(lumaValue, lumaValue, lumaValue));
    }
  }

  image.updatePixels();

}

function intensityGrayscale(image) {
  image.loadPixels();

  for (let i = 0; i < image.width; i++) {
    for (let j = 0; j < image.height; j++) {
      let pixel = image.get(i, j);
      let lumaValue = parseInt((pixel[R] + pixel[G] + pixel[B]) / 3);

      image.set(i, j, color(lumaValue, lumaValue, lumaValue));
    }
  }

  image.updatePixels();

}

// HISTOGRAM
function createHistogram(image, channel, xOffset, yOffset, { color = [255, 255, 255], width = 300, height = HISTOGRAM_HEIGHT }) {
  let maxRange = 256
  let histogram = new Array(maxRange).fill(0);
  
  image.loadPixels();

  for (let i = 0; i < image.width; i++) {
    for (let j = 0; j < image.height; j++) {
      let pixel = image.get(i, j);
      let lumaValue = (0.2126 * pixel[R]) + (0.7152 * pixel[G]) + (0.0722 * pixel[B])

      histogram[ channel == 'L' ? Math.floor(lumaValue): pixel[channel] ]++;
    }
  }

  let colorAux = [0, 0, 0];
  push();
  // stroke(...color);
  translate(xOffset, 0);
  let rightLimit;

  for (let x = 0; x <= maxRange; x++) {
    let index = histogram[x];
    let y1 = parseInt(map(index, 0, max(histogram), yOffset, yOffset - height));
    let y2 = yOffset;
    let xPos = map(x, 0, maxRange, 0, width);
    colorAux[channel] = x;

    if(channel == 'L') {
      colorAux[R] = colorAux[G] = colorAux[B] = x;
    }

    stroke(...colorAux);
    line(xPos, y1, xPos, y2);
    if(x == maxRange) rightLimit = xPos;
  }

  pop();

  return rightLimit + xOffset;
}

// CONVOLUTIONAL MASKS

const MASK_EDGE_DETECTION1 = [
  [ 1,  0, -1],
  [ 0,  0,  0],
  [-1,  0,  1],
]

const MASK_EDGE_DETECTION2 = [
  [-1, -1, -1],
  [-1,  8, -1],
  [-1, -1, -1],
]

const MASK_IDENTITY = [
  [ 0,  0,  0],
  [ 0,  1,  0],
  [ 0,  0,  0],
]

const MASK_AVGBLUR = [
  [ 0.1111111111111111,  0.1111111111111111,  0.1111111111111111],
  [ 0.1111111111111111,  0.1111111111111111,  0.1111111111111111],
  [ 0.1111111111111111,  0.1111111111111111,  0.1111111111111111],
]

const MASK_AVGBLUR11 = [
  [ 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01 ],
  [ 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01 ],
  [ 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01 ],
  [ 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01 ],
  [ 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01 ],
  [ 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01 ],
  [ 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01 ],
  [ 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01 ],
  [ 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01 ],
  [ 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01 ],
  [ 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01 ],
]

const MASK_GAUSSIAN11 = [
  [0,	0,	0,	0,	0.000001,	0.000001,	0.000001,	0,	0,	0,	0],
  [0,	0,	0.000001,	0.000014,	0.000055,	0.000088,	0.000055,	0.000014,	0.000001,	0,	0],
  [0,	0.000001,	0.000036,	0.000362,	0.001445,	0.002289,	0.001445,	0.000362,	0.000036,	0.000001,	0],
  [0,	0.000014,	0.000362,	0.003672,	0.014648,	0.023204,	0.014648,	0.003672,	0.000362,	0.000014,	0],
  [0.000001,	0.000055,	0.001445,	0.014648,	0.058433,	0.092564,	0.058433,	0.014648,	0.001445,	0.000055,	0.000001],
  [0.000001,	0.000088,	0.002289,	0.023204,	0.092564,	0.146632,	0.092564,	0.023204,	0.002289,	0.000088,	0.000001],
  [0.000001,	0.000055,	0.001445,	0.014648,	0.058433,	0.092564,	0.058433,	0.014648,	0.001445,	0.000055,	0.000001],
  [0,	0.000014,	0.000362,	0.003672,	0.014648,	0.023204,	0.014648,	0.003672,	0.000362,	0.000014,	0],
  [0,	0.000001,	0.000036,	0.000362,	0.001445,	0.002289,	0.001445,	0.000362,	0.000036,	0.000001,	0],
  [0,	0,	0.000001,	0.000014,	0.000055,	0.000088,	0.000055,	0.000014,	0.000001,	0,	0],
  [0,	0,	0,	0,	0.000001,	0.000001,	0.000001,	0,	0,	0,	0]
]

const MASK_SHARPEN = [
  [ 0, -1,  0],
  [-1,  5, -1],
  [ 0, -1,  0],
]

function inBounds(x, y, bounds) {
  if((x >= 0 && x < bounds) && (y >= 0 && y < bounds)) return true;
  return false;
}

function applyMask(image, mask) {
  image.loadPixels();
  img_base.loadPixels();

  for (let i = 0; i < image.width; i++) {
    for (let j = 0; j < image.height; j++) {

      let pixelValue = [0, 0, 0];
      for (let x = 0, x_aux = -Math.floor(mask.length / 2); x < mask.length; x++, x_aux++) {
        for (let y = 0, y_aux = -Math.floor(mask.length / 2); y < mask.length; y++, y_aux++) {

          if(inBounds(i + x_aux, j + y_aux, image.width)) {
            let pixel = img_base.get(i + x_aux, j + y_aux);
            pixelValue[R] += pixel[R] * mask[x][y];
            pixelValue[G] += pixel[G] * mask[x][y];
            pixelValue[B] += pixel[B] * mask[x][y];
          }
          
        }        
      }

      image.set(i, j, color(...pixelValue));
    }
  }

  image.updatePixels();
}
