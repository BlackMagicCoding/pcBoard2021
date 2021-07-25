// measurements in mm

twoParts = true; // true if you want the cage to be 2 smaller parts instead of a single item - works fine for me in two parts
twoPartsStrength = 40; // the length of the two cage parts - can be changed, 40 is mine

$fn = 16; // number of facets when drawing a circle
psuX = 151; // width of psu itself
psuY = 164; // depth of psu itself
psuZ = 87; // height of psu itself

strength = 4; // strength of material
baseSupport = 10; // width of the two strips with the screw holes at the sides of the cage
baseStrength = strength + baseSupport; // just a little helper
frameSupport = 5; // width of the cage elements

screwRadius = 1.5; // for m3 screws
screwDistanceY = (frameSupport + strength) / 2; // y distance of the screw inside the base support

 module cylinder_outer(height, radius, fn){ // because the ootb cylinder is undersized for drill holes! find this somewhere in the internets
   fudge = 1 / cos(180 / fn);
   cylinder(h = height, r = radius * fudge, $fn = fn);
}

// holes for single element design
holesDefault =  [
                    [baseSupport / 2, screwDistanceY],
                    [baseSupport / 2, psuY + 2 * strength - screwDistanceY],
                    [baseSupport / 2 + psuX + 2 * strength + baseSupport, screwDistanceY],
                    [baseSupport / 2 + psuX + 2 * strength + baseSupport, psuY + 2 * strength - screwDistanceY]
                ];

// additional holes if you print in two parts
holesTwoParts = [
                    [holesDefault[0].x, twoPartsStrength - screwDistanceY],
                    [holesDefault[1].x, psuY + 2 * strength - twoPartsStrength + screwDistanceY],
                    [holesDefault[2].x, twoPartsStrength - screwDistanceY],
                    [holesDefault[3].x, psuY + 2 * strength - twoPartsStrength + screwDistanceY]
                ];

// small module to drill holes in the base
module drillHoles(holeArray, radius){
    for(i = [0:1:len(holeArray) - 1]){
        translate([holeArray[i].x, holeArray[i].y, - 1])
            cylinder(strength + 2, radius, radius);
    }
}

difference(){
    
  union(){ 
    // this is the base on the bottom which will be bolted onto the surface
    cube([psuX + 2 * baseStrength, psuY + 2 * strength, strength]);

    // this block will turn into the cage
    translate([baseSupport, 0, 0]){
      cube([psuX + 2 * strength, psuY + 2 * strength, psuZ + strength]);
    }
  }
  
  // removing the area of the psu itself
  translate([baseStrength, strength, - 1]){
    cube([psuX, psuY, psuZ + 1]);
  }
  
  // removing the sides on the x axis
  translate([baseSupport - 1, strength + frameSupport, strength + frameSupport]){
    cube([psuX + 3 * strength, psuY - frameSupport - strength, psuZ -  2 * frameSupport - strength]);
  }
  
  // removing the sides on the y axis
  translate([baseSupport + frameSupport + strength, -1, frameSupport + strength]){
    cube([psuX - frameSupport - strength, psuY + 3 * strength, psuZ - 2 * frameSupport - strength]);
  }
  
  // removing the side on top
  translate([baseSupport + frameSupport + strength, frameSupport + strength, psuZ - 1]){
    cube([psuX - frameSupport - strength, psuY - frameSupport - strength, strength + 2]);
  }
  
  // IMPORTANT - removing the support of the side where power cables come out of the psu, otherwise they would be partly blocked - might not apply on your psu
  translate([baseSupport + strength, -1, frameSupport + strength]){
    cube([frameSupport + 1, strength + 2, psuZ - 2 * frameSupport - strength]);
  }
  
  drillHoles(holesDefault, screwRadius);
  
  // stuff to do when you you print in two parts
  if(twoParts){
      translate([-1, twoPartsStrength, -1]){
        // removing a chunk in the middle of the y axis, so we get 2 parts
        cube([psuX + 2 * baseStrength + 2, psuY + 2 * strength - 2 * twoPartsStrength, psuZ + strength + 2]);
      }
      // we need additional holes for the two part design
      drillHoles(holesTwoParts, screwRadius);
  }
  
}
