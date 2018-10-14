

snapTestOn();

module wristBand(width, length) {
  difference() {
    cube([length, width, 0.3]);
    translate([width/2, width/2, 0])
      cylinder(d=10, h=0.3, $fn=50);
  }
  translate([length-width/2, width/2, 0])
    snapButtonMale(width, 1, 5, 3);
  translate([width/2, width/2, 0]) {
    snapButtonFemale(width, 1, 5, 3);
  }

}

module snapTestOn() {
  snapButtonMale(10, 1, 4, 3);
  translate([0,0,1])
  snapButtonFemale(10, 1, 4, 3);
  translate([15, 0, 0]) {
    snapButtonMale(10, 1, 6, 3);
    translate([0,0,1])
    snapButtonFemale(10, 1, 6, 3);
  }
}

// Tolerance 0.2 is tight to the point of not being removable
module snapButtonFemale(baseDiam, baseH, pinDiam, pinZ, tolerance=0.3) {
  difference() {
    cylinder(d=baseDiam, h=baseH, $fn=50);
    cylinder(d=pinDiam + 2, h=pinZ, $fn=50);
  }
  translate([0, 0, (pinZ - 1) / 2]) {
    rotate_extrude(convexity = 10, $fn=50)
    translate([(pinDiam + pinZ - 1) / 2 + tolerance, 0, 0])
      circle(d=pinZ - 1, $fn = 50);
  }
}

module snapButtonMale(baseDiam, baseH, pinDiam, pinZ) {
  pinZ = pinZ*3/4;
  cylinder(d=baseDiam, h=baseH, $fn=50);
  translate([0, 0, baseH]) {
    difference() {
      union() {
        cylinder(d=pinDiam, h=pinZ, $fn=20);
        translate([0, 0, pinZ - 1/2]) {
          rotate_extrude(convexity = 10, $fn=50)
          translate([pinDiam/2, 0, 0])
          circle(d=1, $fn = 50);
        }
      }
      cylinder(d=pinDiam/2, h=pinZ+1, $fn=40);
      translate([-baseDiam/2, -0.25, 0])
        cube([baseDiam, 0.5, pinZ]);
    }
  }
}