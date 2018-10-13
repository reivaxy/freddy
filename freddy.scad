finger(20, 40, 40, 1);

module finger(innerDiameter, lowerLength, upperLength, thickness) {
  outerDiameter = innerDiameter + 2* thickness;

  difference() {
    cylinder(d = outerDiameter, h = lowerLength, $fn=100);
    cylinder(d = innerDiameter, h = lowerLength, $fn=100);
    translate([-outerDiameter/2, lowerLength/2, 8 + outerDiameter/2]) {
      rotate(90, [1, 0, 0]) {
        cylinder(d = outerDiameter, h = lowerLength, $fn=100);

      }
    }
    translate([-outerDiameter, -outerDiameter/2 - 1, lowerLength/2]) {
      cube([outerDiameter, outerDiameter + 2, lowerLength]);
    }
  }
  hingeSide = 6;
  translate([-hingeSide, -outerDiameter/2, lowerLength - hingeSide*2]) {
    difference() {
      cube([hingeSide, outerDiameter, hingeSide*2]);
      translate([0, thickness, 0]) {
        cube([hingeSide, innerDiameter, hingeSide*2]);
      }
      translate([0, outerDiameter, 0]) {
        rotate(90, [1, 0, 0]) {
          cylinder(d=hingeSide*2, h=outerDiameter, $fn=100);
        }
      }
    }
  }

}