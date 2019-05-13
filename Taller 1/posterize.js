let pi_base;
let pi_posterized;

let pi_aspectRatio;
let canvas;

let pi_gradient;

function preload() {
  let source = './images/Grading.jpg';

  pi_base = loadImage(source);  
  pi_posterized = loadImage(source);  
  pi_gradient = loadImage(source);  
}

function setup() {
  canvas = createCanvas(window.innerWidth, window.innerHeight);
  canvas.parent('canvas');
  pi_aspectRatio = pi_base.width / pi_base.height;
  
  let size = 400;
  limitPalette(pi_base, 3);


  // posterize(pi_gradient, 80);
  gradientMap(pi_gradient, [[32, 78, 29], [180, 255, 0], [26, 26, 126], [255, 43, 22]]);
  image(pi_base, 0, 0, size, size / pi_aspectRatio);
  image(pi_gradient, 450, 0, size, size / pi_aspectRatio);
}

function draw() {
}

// Functions

function posterize(image, value = 255) {
  image.loadPixels()
  let intervalSize = value;

  for (let i = 0; i < image.width; i++) {
    for (let j = 0; j < image.height; j++) {
      let pixel = image.get(i, j); 

      let R = Math.floor(pixel[0] / intervalSize) * intervalSize + intervalSize / 2;
      let G = Math.floor(pixel[1] / intervalSize) * intervalSize + intervalSize / 2;
      let B = Math.floor(pixel[2] / intervalSize) * intervalSize + intervalSize / 2;

      image.set(i, j, color(R, G, B)); 
    }
  }

  image.updatePixels();
}

function createMatrix(width, height, value) {
  let matrix = [];

  for (let i = 0; i < width; i++) {
    matrix.push([]);

    for(let j = 0; j < height; j++) {
      matrix[i].push(value);
    }
  }

  return matrix;
}

function limitPalette(image, colors) {
  let container = document.getElementById('container');

  image.loadPixels()
  let intervalSize = 255 / colors;
  let step_color = createMatrix(image.width, image.height, 0);
  let average = [];

  for(let i = 0; i < colors; i++) {
    average.push({ value: [0, 0, 0], count: 0 });
  }
                                                                                                                                              

  for (let i = 0; i < image.width; i++) {
    for (let j = 0; j < image.height; j++) {
      let pixel = image.get(i, j); 
      let avg = (pixel[0] + pixel[1] + pixel[2]) / 3;

      let position = Math.floor(avg / intervalSize);

      step_color[i][j] = position;
      average[position].value[0] += pixel[0];
      average[position].value[1] += pixel[1];
      average[position].value[2] += pixel[2];
      average[position].count += 1;
    }
  }

  for(let i = 0; i < colors; i++) {
    average[i].value[0] /= average[i].count;
    average[i].value[1] /= average[i].count;
    average[i].value[2] /= average[i].count;

    let box = document.createElement('div');
    box.classList.add('color-box');
    box.style.backgroundColor = `rgb(${average[i].value[0]}, ${average[i].value[1]}, ${average[i].value[2]})`;

    container.appendChild(box);
  }

  for (let i = 0; i < image.width; i++) {
    for (let j = 0; j < image.height; j++) {
      let avgColor = average[step_color[i][j]].value;
      image.set(i, j, color(...avgColor)); 
    }
  }

  image.updatePixels();
}

function gradientMap(image, colorArray) {
  let gradient = new Array(255);
  let colorIndex = 0;
  let colorSize = colorArray.length - 1;
  let colorInterval = Math.ceil(255 / colorSize);

  let lastIndex;
  try {
    for(let i = 0; i < 255; i++) {
      lastIndex = i;
      if(i!= 0 && i % (colorInterval) == 0) colorIndex++;
      
      let endPercentage =  ((i) % colorInterval) / colorInterval;
      let startPercentage = 1 - endPercentage;
  
      let R = colorArray[colorIndex][0] * startPercentage + colorArray[colorIndex + 1][0] * endPercentage;
      let G = colorArray[colorIndex][1] * startPercentage + colorArray[colorIndex + 1][1] * endPercentage;
      let B = colorArray[colorIndex][2] * startPercentage + colorArray[colorIndex + 1][2] * endPercentage;
      
      gradient[i] = [Math.round(R), Math.round(G), Math.round(B)];
    }
    
  } catch (error) {
    console.log("Failed on index", colorIndex);    
    console.log("Last index", lastIndex);    
    console.log("color interval", colorInterval);    
    console.log(error);
    return;
  }

  console.log(gradient);

  eachPixel(image, pixel => {
    let luminosity = Math.floor((0.2126 * pixel[0]) + (0.7152 * pixel[1]) + (0.0722 * pixel[2]));
    return gradient[luminosity];    
  });
  
}

function eachPixel(image, callback) {
  image.loadPixels();

  for (let i = 0; i < image.width; i++) {
    for (let j = 0; j < image.height; j++) {
      let pixel = image.get(i, j);
      let getColor = callback(pixel)

      image.set(i, j, color(...getColor));
    }
  }

  image.updatePixels();
}

function keyTyped() {
  if (key === 's') {
    pi_gradient.save('pi_gradient', 'png');
  }
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
