


printableFinger(24, 33, 21, 16, 50);

module printableFinger(lowerDiam, lowerLength, upperBottomDiam, upperTopDiam, upperLength) {
  thickness = 1;
  hingeDiam = 3;
  lowerFinger(lowerDiam, lowerLength, thickness, hingeDiam);
  translate([lowerDiam + 5, 0, 0])
    upperFinger(upperBottomDiam, upperTopDiam, upperLength, thickness, hingeDiam);
}

module finger(lowerDiam, lowerLength, upperBottomDiam, upperTopDiam, upperLength) {
  thickness = 1;
  hingeDiam = 3;
  lowerFinger(lowerDiam, lowerLength, thickness, hingeDiam);
  translate([0, 0, lowerLength - 2* hingeDiam])
    upperFinger(upperBottomDiam, upperTopDiam, upperLength, thickness, hingeDiam);
}


//lowerFinger(20, 40, 1, 3);
// upperFinger(18, 14, 40, 1, 3);

module upperFinger(innerBottomDiameter, innerTopDiameter, upperLength, thickness, hingeDiameter) {
  outerBottomDiameter = innerBottomDiameter + 2* thickness;
  outerTopDiameter = innerTopDiameter + 2* thickness;

  difference() {
    cylinder(d1 = outerBottomDiameter, d2 = outerTopDiameter, h = upperLength, $fn=100);
    cylinder(d1 = innerBottomDiameter, d2 = innerTopDiameter, h = upperLength, $fn=100);
    // Cut half of cylinder
    translate([-outerBottomDiameter, -outerBottomDiameter/2, 0]) {
      cube([outerBottomDiameter, outerBottomDiameter, upperLength - outerBottomDiameter]);
    }
    // Top of cut is rounded, which eases printing with no support
    color("blue")
    translate([-outerBottomDiameter/2, outerBottomDiameter/2, upperLength - outerBottomDiameter]) {
      rotate(90, [1, 0, 0]) {
        cylinder(d=outerBottomDiameter, h=outerBottomDiameter, $fn=100);
      }
    }
  }
  // Top sphere
  translate([0, 0, upperLength]) {
    difference() {
      sphere(d=outerTopDiameter, $fn=100);
      sphere(d=innerTopDiameter, $fn=100);
      // Cut lower half of sphere
      translate([-outerTopDiameter/2, -outerTopDiameter/2, -outerTopDiameter]) {
        cube(outerTopDiameter);
      }
    }
  }
  // Hinges to connect lower finger
  hingeSide = hingeDiameter * 2;
  translate([-hingeSide, -outerBottomDiameter/2, 0]) {
    difference() {
      union() {
        translate([hingeSide/2, 0, 0]) {
          cube([hingeSide/2, outerBottomDiameter, hingeSide]);
        }
        translate([hingeSide/2, outerBottomDiameter, hingeSide/2]) {
          rotate(90, [1, 0, 0]) {
            cylinder(d=hingeSide, h=outerBottomDiameter, $fn=100);
          }
        }
        hingeLength = 2;
        translate([hingeSide/2, outerBottomDiameter + hingeLength, hingeSide/2]) {
          rotate(90, [1, 0, 0]) {
            cylinder(d=hinge, h=outerBottomDiameter + hingeLength*2, $fn=100);
          }
        }

      }
      translate([0, thickness, 0]) {
        cube([hingeSide, innerBottomDiameter, hingeSide*2]);
      }
    }
  }
}


module lowerFinger(innerDiameter, lowerLength, thickness, hingeDiameter) {
  outerDiameter = innerDiameter + 2* thickness;

  difference() {
    cylinder(d = outerDiameter, h = lowerLength, $fn=100);
    cylinder(d = innerDiameter, h = lowerLength, $fn=100);

    // Rounded cut in cylinder lower half, inner-hand
    color("red")
    translate([-outerDiameter/2, lowerLength/2, 8 + outerDiameter/2]) {
      rotate(90, [1, 0, 0]) {
        cylinder(d = outerDiameter, h = lowerLength, $fn=100);
      }
    }
    // Remove cylinder inner-hand upper half
    color("blue")
    translate([-outerDiameter, -outerDiameter/2 - 1, 8 + outerDiameter/2]) {
      cube([outerDiameter, outerDiameter + 2, lowerLength]);
    }
    // Rounded cut in cylinder upper half, outer-hand
    color("yellow")
    translate([outerDiameter/2, lowerLength/2, lowerLength  + hingeDiameter + 2]) {
      rotate(90, [1, 0, 0]) {
        cylinder(d = outerDiameter, h = lowerLength, $fn=100);
      }
    }
  }

  // Hinges to connect upper finger
  hingeSide = hingeDiameter * 2;
  translate([-hingeSide, -outerDiameter/2, lowerLength - hingeSide*2]) {
    difference() {
      union() {
        translate([hingeSide/2, 0, 0]) {
          cube([hingeSide/2, outerDiameter, hingeSide*2]);
        }
        translate([hingeSide/2, outerDiameter, hingeSide*3/2]) {
          rotate(90, [1, 0, 0]) {
            cylinder(d=hingeSide, h=outerDiameter, $fn=100);
          }
        }
      }
      translate([0, thickness, 0]) {
        cube([hingeSide, innerDiameter, hingeSide*2]);
      }
      // bottom hinge side is rounded to print with no support
      color("purple")
      translate([0, outerDiameter, 0.6]) {
        rotate(90, [1, 0, 0]) {
          cylinder(d=hingeSide*2, h=outerDiameter, $fn=100);
        }
      }
      // Hole for hinges
      translate([hingeSide/2, outerDiameter+1, hingeSide*2 - hingeDiameter]) {
        rotate(90, [1, 0, 0]) {
          cylinder(d=hingeDiameter, h=outerDiameter+2, $fn=100);
        }
      }
    }
  }

}