



//lowerFinger(20, 40, 1, 3);
upperFinger(18, 14, 50, 1, 3);

module upperFinger(innerBottomDiameter, innerTopDiameter, upperLength, thickness, hingeDiameter) {
  outerBottomDiameter = innerBottomDiameter + 2* thickness;
  outerTopDiameter = innerTopDiameter + 2* thickness;

  difference() {
    cylinder(d1 = outerBottomDiameter, d2 = outerTopDiameter, h = upperLength, $fn=100);
    cylinder(d1 = innerBottomDiameter, d2 = innerTopDiameter, h = upperLength, $fn=100);
    translate([-outerBottomDiameter, -outerBottomDiameter/2, 0]) {
      cube([outerBottomDiameter, outerBottomDiameter, upperLength - outerBottomDiameter]);
    }
    translate([-outerBottomDiameter/2, outerBottomDiameter/2, upperLength - outerBottomDiameter]) {
      rotate(90, [1, 0, 0]) {
        cylinder(d=outerBottomDiameter, h=outerBottomDiameter, $fn=100);
      }
    }

  }
  translate([0, 0, upperLength]) {
    difference() {
      sphere(d=outerTopDiameter, $fn=100);
      sphere(d=innerTopDiameter, $fn=100);
      translate([-outerTopDiameter/2, -outerTopDiameter/2, -outerTopDiameter]) {
        cube(outerTopDiameter);
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
    translate([-outerDiameter, -outerDiameter/2 - 1, lowerLength/2]) {
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

  hingeSide = hingeDiameter * 2;
  translate([-hingeSide, -outerDiameter/2, lowerLength - hingeSide*2]) {
    difference() {
      // Hinge side
      cube([hingeSide, outerDiameter, hingeSide*2]);
      translate([0, thickness, 0]) {
        cube([hingeSide, innerDiameter, hingeSide*2]);
      }
      // lower hinge side is rounded to print with no support
      color("purple")
      translate([0, outerDiameter, 0]) {
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