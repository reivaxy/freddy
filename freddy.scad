

//index();
majeur();
//annulaire();
//auriculaire();

module auriculaire() {
  printableFinger(18, 17, 18, 16, 15, 34);
}
module annulaire() {
  printableFinger(20, 19, 33, 18, 15, 40);
}
module majeur() {
  printableFinger(23, 23, 40, 21, 16, 50);
}
module index() {
  printableFinger(24, 23, 33, 21, 16, 44);
  //finger(24, 23, 33, 21, 16, 44);
}

module printableFinger(lowerBottomDiam, lowerTopDiam, lowerLength, upperBottomDiam, upperTopDiam, upperLength) {
  thickness = 1;
  hingeDiam = 3;
  lowerFinger(lowerBottomDiam, lowerTopDiam, lowerLength, thickness, hingeDiam);
  translate([lowerBottomDiam + 5, 0, 0])
    upperFinger(upperBottomDiam, upperTopDiam, upperLength, thickness, hingeDiam);
  translate([-40, 30, 0])
  rotate(90, [0, 0, 1])
  rotate(-10, [0, 1, 0])
  rotate(90, [1, 0, 0])
    claw(upperBottomDiam, upperTopDiam, upperLength);
}

thickness = 1;
hingeDiam = 3;
module finger(lowerBottomDiam, lowerTopDiam, lowerLength, upperBottomDiam, upperTopDiam, upperLength) {
  lowerFinger(lowerBottomDiam, lowerTopDiam, lowerLength, thickness, hingeDiam);
  translate([0, 0, lowerLength - 2* hingeDiam])
    upperFinger(upperBottomDiam, upperTopDiam, upperLength, thickness, hingeDiam);
  translate([-3, 0, upperLength+2])
    claw(upperBottomDiam, upperTopDiam, upperLength);
}

module claw(upperBottomDiam, upperTopDiam, upperLength) {
  difference() {
    rotate(90, [0, 0, 1]) {
      difference() {
        obus();
        translate([0, 12, 0])
          scale([3, 1, 1.09])
          obus();
        rotate(10, [0, 0, 1]) {
          translate([0, -20, 0])
            cube([20, 40, 150]);
        }
        rotate(-10, [0, 0, 1]) {
          translate([-20, -20, 0])
            cube([20, 40, 150]);
        }
      }
    }
    translate([2.6, 0, -upperLength/2]) {
      outerBottomDiameter = upperBottomDiam + 2* thickness;
      outerTopDiameter = upperTopDiam + 2* thickness;
      cylinder(d1 = outerBottomDiameter, d2 = outerTopDiameter, h = upperLength, $fn=50);
      // Top sphere
      translate([0, 0, upperLength]) {
        sphere(d=outerTopDiameter, $fn=50);
      }
    }
  }
}

module obus() {
  scale([1, 2, 1]) {
    translate([0, 0, 100])
      scale([1, 1, 4])
        sphere(d=15, $fn=100);
    cylinder(d=15, h=100, $fn=100);
  }
}

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
      sphere(d=outerTopDiameter, $fn=50);
      sphere(d=innerTopDiameter, $fn=50);
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
            cylinder(d=hingeDiameter - 0.5, h=outerBottomDiameter + hingeLength*2, $fn=100);
          }
        }

      }
      translate([0, thickness, 0]) {
        cube([hingeSide, innerBottomDiameter, hingeSide*2]);
      }
    }
  }
}


module lowerFinger(innerBottomDiameter, innerTopDiameter, lowerLength, thickness, hingeDiameter) {
  outerBottomDiameter = innerBottomDiameter + 2* thickness;
  outerTopDiameter = innerTopDiameter + 2* thickness;

  difference() {
    cylinder(d1 = outerBottomDiameter, d2 = outerTopDiameter, h = lowerLength, $fn=100);
    cylinder(d1 = innerBottomDiameter, d2 = innerTopDiameter, h = lowerLength, $fn=100);

    // Rounded cut in cylinder lower half, inner-hand
    color("red")
    translate([-outerBottomDiameter/2, outerBottomDiameter/2 + 5, lowerLength/5 + outerBottomDiameter/2]) {
      rotate(90, [1, 0, 0]) {
        cylinder(d = outerBottomDiameter, h = outerBottomDiameter + 10, $fn=100);
      }
    }
    // Remove cylinder inner-hand upper half
    color("blue")
    translate([-outerBottomDiameter, -outerBottomDiameter/2 - 1, 8 + outerBottomDiameter/2]) {
      cube([outerBottomDiameter, outerBottomDiameter + 2, lowerLength]);
    }
    // Rounded cut in cylinder upper half, outer-hand
    color("yellow")
    translate([outerTopDiameter/2, outerTopDiameter/2 + 5, lowerLength  + hingeDiameter + 2]) {
      rotate(90, [1, 0, 0]) {
        cylinder(d = outerTopDiameter, h = outerTopDiameter + 10, $fn=100);
      }
    }
  }

  // Hinges to connect upper finger
  hingeSide = hingeDiameter * 2;
  translate([-hingeSide, -outerTopDiameter/2, lowerLength - hingeSide*2]) {
    difference() {
      union() {
        translate([hingeSide/2, 0, 0]) {
          cube([hingeSide/2, outerTopDiameter, hingeSide*2]);
        }
        translate([hingeSide/2, outerTopDiameter, hingeSide*3/2]) {
          rotate(90, [1, 0, 0]) {
            cylinder(d=hingeSide, h=outerTopDiameter, $fn=100);
          }
        }
      }
      translate([0, thickness, 0]) {
        cube([hingeSide, innerTopDiameter, hingeSide*2]);
      }
      // bottom hinge side is rounded to print with no support
      color("purple")
      translate([0, outerTopDiameter, 0.6]) {
        rotate(90, [1, 0, 0]) {
          cylinder(d=hingeSide*2, h=outerTopDiameter, $fn=100);
        }
      }
      // Hole for hinges
      translate([hingeSide/2, outerBottomDiameter+1, hingeSide*2 - hingeDiameter]) {
        rotate(90, [1, 0, 0]) {
          cylinder(d=hingeDiameter, h=outerBottomDiameter+2, $fn=100);
        }
      }
    }
  }

}