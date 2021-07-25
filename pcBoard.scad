// measurements in mm

$fn = 16;
drawComponents = true; // shows components on top of the board, so you get a better feelign what sits where
spc = 15; // standard spacer between components and a slit
gap = 20; // default width of a slit

hole_m3 = 1.75;
hole_m5 = 2.75;
boardHeight = 3;

// components [x, y, z, x_offset, y_offset]
mb = [305, 244, 3, 0, 0];
gfx = [98.5, 203, 35, mb.x + 2 * spc + gap, 0];
fan = [120, 150, 63, 0, mb.y + 2 * spc + gap];
boardWidth = mb.x + 2 * spc + gap + gfx.x;
boardLength = mb.y + spc + gap + spc + fan.y;
psu_tmp = [180, 169, 90]; // temporary psu component, need variables for offset
ssd = [70, 100, 10];
spcSSD = (boardWidth - psu_tmp.x - fan.x - 2 * ssd.x) / 3;
ssd1 = concat(ssd, fan.x + spcSSD, boardLength - ssd.y);
ssd2 = concat(ssd, ssd1[3] + ssd.x + spcSSD, ssd1[4]);
psu = concat(psu_tmp, [boardWidth - psu_tmp.x, boardLength - psu_tmp.y]);

// slits [x, y, x_offset, y_offset]
riser = [gap, 100, mb.x + spc, 35];
gfx_pwr = [riser.x, riser.x, riser[2], 158];
psu_cbl = [115, gap, boardWidth - psu.x + 35, mb.y - gap];
mb_pwr = [60, gap, 70, mb.y + spc];
mb_sata = [50, gap, mb.x - 99, mb.y + spc];
ssd1_cbl = [ssd.x, gap, fan.x + spcSSD, boardLength - ssd.y - spc - gap];
ssd2_cbl = [ssd.x, gap, fan.x + 2 * spcSSD + ssd.x, boardLength - ssd.y - spc - gap];


// mounting holes of motherboard (ATX)
mbHoles = [
    [6.35, 33.02],
    [6.35, 165.1],
    [6.35, 237.49],
    [163.83, 10.16],
    [163.83, 165.1],
    [163.83, 237.49],
    [288.29, 10.16],
    [288.29, 165.1],
    [288.29, 237.49]
];

gfxHoles = [
    [25.5, 167],
    [92, 167],
    [7, 97],
    [92, 82]
];

fanHoles = [
    [7.5, 26],
    [112.5, 26],
    [7.5, 131],
    [112.5, 131]
];
ssdHoles = [
    [4, 14],
    [64.72, 14],
    [4, 90.6],
    [64.72, 90.6]
];
psuHoles = [
    [5, 6],
    [psu.x - 5, 6],
    [5, 32],
    [psu.x - 5, 32],
    [5, psu.y - 32],
    [psu.x - 5, psu.y - 32],
    [5, psu.y - 6],
    [psu.x - 5, psu.y - 6],
];

mountHoles = [
    [mb.x + (2 * spc + riser.x) / 2, 18],
    [18, mb.y + (2 * spc + mb_pwr.y) / 2],
    [boardWidth - 18, gfx.y + (boardLength - gfx.y - psu.y) / 2],
    [fan.x + spcSSD + ssd.x + spcSSD / 2, ssd1[4] - spc / 2]
];

projection(cut=false){ // projection to create a 2d drawing out of my 3d model - my laser cut company needed a .dxf file and thus you need a 2d drawing
    difference(){
        union(){
            color("green") cube([boardWidth, boardLength, boardHeight]); // board
            drawComponent(mb);
            drawComponent(gfx);
            drawComponent(psu);
            drawComponent(fan);
            drawComponent(ssd1);
            drawComponent(ssd2);
        }
        cutSlit(riser);
        cutSlit(gfx_pwr);
        cutSlit(psu_cbl);
        cutSlit(mb_pwr);
        cutSlit(mb_sata);
        cutSlit(ssd1_cbl);
        cutSlit(ssd2_cbl);

        drillHoles(hole_m3, mbHoles, mb);
        drillHoles(hole_m5, mountHoles, mb);
        drillHoles(hole_m3, fanHoles, fan);
        drillHoles(hole_m3, ssdHoles, ssd1);
        drillHoles(hole_m3, ssdHoles, ssd2);
        drillHoles(hole_m3, psuHoles, psu);
        drillHoles(hole_m3, gfxHoles, gfx);
        drillHoles(57, [[fan.x / 2, (fanHoles[2].y - fanHoles[0].y) / 2 + 26]], fan, $fn=64);
    }
}

// echoing the width and length because i needed that for specification in the order
echo("boardWidth: ", boardWidth);
echo("boardLength: ", boardLength);

module cutSlit(slit){
    translate([slit[2], slit[3], - 1])
        cube([slit.x, slit.y, boardHeight + 2]);
}

module drawComponent(component){
    if(drawComponents){
        translate([component[3], component[4], boardHeight])
            %cube([component.x, component.y, component.z]);
    }
    
}

module drillHoles(radius, holeArray, component){
    for(i = [0:1:len(holeArray) - 1]){
        translate([holeArray[i].x + component[3], holeArray[i].y + component[4], - 1])
            cylinder(boardHeight + 2, radius, radius);
    }
}
