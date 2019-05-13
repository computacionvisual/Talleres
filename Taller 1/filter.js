let canvas;
let img_base;
let img_luma;
let img_mask;
let img_segmentated;
let video_base;


const R = 0, G = 1, B = 2;
const HISTOGRAM_HEIGHT = 230;
const HISTOGRAM_POSITION = 600;

function preload() {
  let image_source = './images/Landscape.jpg';

  img_base = loadImage(image_source);
  img_luma = loadImage(image_source);
  img_segmentated = loadImage(image_source);
  img_mask = loadImage(image_source);

  video_base = createVideo(['./video/Wild.mp4']);
  video_base.loop();
  video_base.volume(0);
}

function setup() {
  canvas = createCanvas(window.innerWidth, window.innerHeight);
  canvas.parent('canvas');
  if(current_mode == 'Image') {
    lumaGrayscale(img_luma);
    lumaGrayscale(img_segmentated);
    applyMask(img_mask, MASK_SHARPEN);

    lastLimit = createHistogram(img_base, 'L', 30, HISTOGRAM_POSIT
    '
    
    
    ION, {height: 130});
                createHistogram(img_base, R, 30, 150, {color: [255, 0, 0], height: 130});
                createHistogram(img_base, G, 30, 150, {color: [0, 255, 0], height: 130});
                createHistogram(img_base, B, 30, 150, {color: [0, 0, 255], height: 130});
    
    segmentateImage(img_luma, img_segmentated, {start: 0, end: 100});

  }

  if(current_mode == 'Video') {
    document.getElementById('test-slider').style = 'display: none';
  }

}

function draw() {
  let aspectRatio = img_base.width / img_base.height;
  let aspectRatioVideo = video_base.width / video_base.height;
  let imageSize = 400;
  let videoSize = 600;

  // Images
  if(current_mode == 'Image') {
    image(img_base, 0, 150, imageSize, imageSize / aspectRatio);
    image(img_luma, 400, 0, imageSize, imageSize / aspectRatio);
    image(img_mask, 400, 300, imageSize, imageSize / aspectRatio);
    image(img_segmentated, 800, 150, imageSize, imageSize / aspectRatio);
  }
  
  // Video
  if(current_mode == 'Video') {
    background(25);

    let lumaVideo = copyImage(video_base);
    image(copyImage(video_base), 10, 300, imageSize, imageSize / aspectRatioVideo);

    if(toggleVideo) {
      lumaGrayscale(lumaVideo);
      image(lumaVideo, 410, 250, videoSize, videoSize / aspectRatioVideo);
    } else {
      applyMask(video_base, MASK_EDGE_DETECTION2);
      image(video_base, 410, 250, videoSize, videoSize / aspectRatioVideo);
    }

    // createHistogram(lumaVideo, 'L', 10, 524, {color: [0, 0, 0], height: 80, width: 200});
  }
  
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
function valueInRange(value, range) {
  if(value >= range.start && value <= range.end) return true;
  return false;
}

function segmentateImage(image_base, image_output, range) {
  image_base.loadPixels();

  for (let i = 0; i < image_base.width; i++) {
    for (let j = 0; j < image_base.height; j++) {
      let pixel = image_base.get(i, j);
      
      if(!valueInRange(pixel[R], range)) {
        image_output.set(i, j, color(0, 0, 0));
      } else {
        image_output.set(i, j, color(pixel[R], pixel[G], pixel[B]));
      }
    }
  }
 
  image_output.updatePixels();
}


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

const MASK_SHARPEN = [
  [ 0, -1,  0],
  [-1,  5, -1],
  [ 0, -1,  0],
]

function inBounds(x, y, bounds) {
  if((x >= 0 && x < bounds.x) && (y >= 0 && y < bounds.y)) return true;
  return false;
}

function applyMask(image, mask) {
  image.loadPixels();

  // let copy = Array(image.width).fill().map(()=>Array(image.height).fill());
  let copy = []

  for (let i = 0; i < image.width; i++) {
    copy.push([])
    for (let j = 0; j < image.height; j++) {
      copy[i].push(image.get(i, j));
    }
  }

  for (let i = 0; i < image.width; i++) {
    for (let j = 0; j < image.height; j++) {

      let pixelValue = [0, 0, 0];
      for (let x = 0, x_aux = -Math.floor(mask.length / 2); x < mask.length; x++, x_aux++) {
        for (let y = 0, y_aux = -Math.floor(mask.length / 2); y < mask.length; y++, y_aux++) {

          if(inBounds(i + x_aux, j + y_aux, {x: image.width, y: image.height})) {
            let pixel = copy[i + x_aux][j + y_aux];
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

function copyImage(image) {
  let new_image = createImage(image.width, image.height);

  image.loadPixels();
  for (let i = 0; i < image.width; i++) {
    for (let j = 0; j < image.height; j++) {
      let pixel = image.get(i, j);

      new_image.set(i, j, color(...pixel));
    }
  }

  new_image.updatePixels();
  return new_image;
}