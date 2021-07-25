
//$fn = 32;
height = 20;
boreHole = 2.75;
radiusTop = 10;
radiusBottom = 18;

difference(){
    cylinder(height, radiusBottom, radiusTop, $fn=64); 
    translate([0, 0, -1]){
        cylinder(height + 2, boreHole, boreHole, $fn=32);
    }
}
