/*
 * Ikea Lack table enclosure for 3DP -- Bottom corners
 *
 * Based on:
 * http://www.thingiverse.com/thing:2864118
 * Original Prusa i3 MK3 ENCLOSURE -Ikea Lack table - 
 *   Prusa Research by cisardom is licensed under 
 *   the Creative Commons - Attribution license.
 *   http://creativecommons.org/licenses/by/3.0/
 *
 * Implementation in OpenSCAD by Robert Jennings <rcj4747>
 */

$fn=200;

leg_width = 50;
leg_edge_radius = 2;
height = 50;
screw_hole_d = 7;
    

/* Create a cylinder with a circumscribed radius. Source:
 * https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/undersized_circular_objects
 */
module cylinder_outer(r, h) {
    fudge = 1/cos(180/$fn);
    cylinder(r=r*fudge, h=h);
}

module leg_bottom(height=height) {
    screw_diameter = 7;
    difference() {
        union() { 
            leg_corner = leg_width - leg_edge_radius;

            translate([leg_corner, leg_corner, 0])
                cylinder(r=leg_edge_radius, h=height);
    
            translate([leg_edge_radius, leg_edge_radius, 0])
                cylinder(r=leg_edge_radius, h=height);
    
            translate([leg_edge_radius, leg_corner, 0])
                cylinder(r=leg_edge_radius,  h=height);
    
            translate([leg_corner, leg_edge_radius, 0])
                cylinder(r=leg_edge_radius, h=height);

            translate([0, leg_edge_radius, 0])
                cube([leg_width, leg_width-leg_edge_radius*2, height]);
            translate([leg_edge_radius, 0, 0,])
                cube([leg_width-leg_edge_radius*2, leg_width, height]);
        }

        // Screw hole
        //translate([leg_width/2, leg_width/2, -1])
        //    cylinder_outer(r=screw_diameter/2, h=height+2);
    }

}

// Alignment cone parameters
cone_d1 = 36;
cone_d2 = 21;
cone_h = 15;

// Foot
color("red")
translate([0, 0, 20])
difference() {
    translate([-25, -25, 0]) leg_bottom();
    union() {
        // Alignment cone
        cylinder(h=cone_h, d1=cone_d1, d2=cone_d2);
        translate([0, 0, -0.199]) cylinder(h=0.2, d=cone_d1);
        // Screw recess
        well_h = 3.5;
        translate([0, 0, cone_h - 0.1]) cylinder(h=well_h + 0.1, d=16);
        // Screw hole
        translate([0, 0, cone_h + well_h - 0.1])
            cylinder_outer(h=height - cone_h - well_h + 0.2, r=screw_hole_d / 2);
    }
}

// Foot plate
plate_h=1;
color("green")
translate([0, 0, -plate_h])
difference() {
    union() {
        translate([-leg_width / 2, -leg_width / 2, 0])
            leg_bottom(height=plate_h);
        translate([0, 0, plate_h - 0.001])
            difference() {
                // Alignment cone
                cylinder(h=14.5, d1=35, d2=20);
                // Screw recess
                translate([0, 0, 9.5 - 0.1]) cylinder(h=5 + 0.2, d=16);
            }
    }
    // Screw hole
    translate([0, 0, -0.1]) cylinder_outer(h=15.5 + 1, r=screw_hole_d / 2);
}
