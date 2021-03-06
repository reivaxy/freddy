use <snapButton.scad>;

fingers();
translate([-50, -150, 0])
  handPlate();

module fingers() {
  translate([0, -70, 0])
    index();
  translate([0, -25, 0])
    majeur();
  translate([0, 20, 0])
    annulaire();
  translate([0, 65, 0])
    auriculaire();
}

// lowerBottomDiam, lowerTopDiam, lowerLength,
//          upperBottomDiam, upperTopDiam, upperLength,
//               join band width, join band length
module auriculaire() {
  printableFinger(20, 17, 33, 16, 15, 33, 8);
}
module annulaire() {
  printableFinger(23, 20, 34, 20, 16, 44);
}
module majeur() {
  printableFinger(24, 23, 40, 22, 16, 50);
}
module index() {
  printableFinger(24, 22, 33, 21, 16, 44);
  //finger(24, 23, 33, 21, 16, 44);
}

// thin band to join the base of each finger to the hand top plate
module join(width, length) {
  pinWidth = 2.5;
  color("yellow") {
    cube([length - width/2, width, 0.3]);
    translate([length - width/2, width/2, 0])
      cylinder(d=width, h=0.3, $fn=40);
    translate([length - 2*pinWidth, (width - pinWidth)/2, 0])
      cube([pinWidth, pinWidth, 6]);
  }

  // button to block it
  // snapButtonFemale(baseDiam, baseH, pinDiam, pinZ, tolerance=0.3)
  translate([length + 10 , width/2, 0])
   snapButtonFemale(10, 1.8, pinWidth, 3, tolerance=0.2);
}

module handPlate() {
  z = 2;
  zThin = 0.3;
  A = [5, 45];
  B = [23.25, 52];
  C = [46.5, 55];
  D = [69.75, 52];
  E = [90, 45];
  F = [83,0];
  G = [10, 0];
  difference() {
    linear_extrude(z)
      polygon([A, B, C, D, E, F, G]);

    // Creases for articulation
    crease(zThin, 1, B, [33, 0]);
    crease(zThin, 1, C, [47, 0]);
    crease(zThin, 1, D, [61, 0]);
    translate([0, 30, 0])
      rotate(90, [0, 0, -1])
        crease(zThin, 1, [0, 0], [0, 100]);

    // Creases for mobile finger joins
    crease(0, 3, [14,44], [17, 35]);
    crease(0, 3, [35,48], [38, 37]);
    crease(0, 3, [59,48], [57, 37]);
    crease(0, 3, [81,43], [77, 34]);
  }
  translate([-60, 15])
    wristBand(10, 230);
}

module crease(thin, width, topPoint, bottomPoint) {
  topPointLeft = [topPoint[0] - width/2, topPoint[1] + width/2];
  topPointRight = [topPoint[0] + width/2, topPoint[1] + width/2];
  bottomPointLeft = [bottomPoint[0] - width/2, bottomPoint[1] - width/2];
  bottomPointRight = [bottomPoint[0] + width/2, bottomPoint[1] - width/2];
  translate([0, 0, thin]) {
    linear_extrude(10) {
      polygon([topPointLeft, topPointRight, bottomPointRight, bottomPointLeft]);
    }
  }
}

thickness = 1;
hingeDiam = 3;
module printableFinger(lowerBottomDiam, lowerTopDiam, lowerLength,
                       upperBottomDiam, upperTopDiam, upperLength, joinWidth=13, joinLength=27) {

  //upperFinger(upperBottomDiam, upperTopDiam, upperLength, thickness, hingeDiam);
  translate([lowerBottomDiam + 5, 0, 0])
    lowerFinger(lowerBottomDiam, lowerTopDiam, lowerLength, thickness, hingeDiam, joinWidth, joinLength);
  translate([-40, 15, 0])
  rotate(90, [0, 0, 1])
  rotate(-10, [0, 1, 0])
  rotate(90, [1, 0, 0])
    claw(upperBottomDiam, upperTopDiam, upperLength);
}

module finger(lowerBottomDiam, lowerTopDiam, lowerLength,
                        upperBottomDiam, upperTopDiam, upperLength, joinWidth=13, joinLength=35) {
  lowerFinger(lowerBottomDiam, lowerTopDiam, lowerLength, thickness, hingeDiam, joinWidth, joinLength);
  translate([0, 0, lowerLength - 2* hingeDiam])
    upperFinger(upperBottomDiam, upperTopDiam, upperLength, thickness, hingeDiam);
  translate([-3, 0, upperLength+2])
    claw(upperBottomDiam, upperTopDiam, upperLength);
}

module claw(upperBottomDiam, upperTopDiam, upperLength) {
  difference() {
    rotate(90, [0, 0, 1]) {
      difference() {
        clawCore();
        translate([0, 12, 0])
          scale([3, 1, 1.09])
          clawCore();
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

module clawCore() {
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


module lowerFinger(innerBottomDiameter, innerTopDiameter, lowerLength,
                         thickness, hingeDiameter, joinWidth, joinLength) {
  outerBottomDiameter = innerBottomDiameter + 2* thickness;
  outerTopDiameter = innerTopDiameter + 2* thickness;

  difference() {
    union() {
      cylinder(d1 = outerBottomDiameter, d2 = outerTopDiameter, h = lowerLength, $fn=100);

      // Flat zone to attach the band to join the hand plate
      translate([0, -joinWidth/2, 0]) {
        color("blue")
        cube([outerBottomDiameter/2, joinWidth, joinWidth + 3]);
        // Add a fake rivet on the flat zone
        translate([outerBottomDiameter/2, joinWidth/2, (joinWidth + 3)/2])
          rotate(90, [0, 1, 0])
            cylinder(d=joinWidth*0.7, h=1, $fn=50);
      }
      // band to join the hand plate
      translate([outerBottomDiameter/2, -joinWidth/2, 0]) {
        join(joinWidth, joinLength);
      }
    }
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