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

module leg_body(height=height) {
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
module foot(height=height) {
    difference() {
        translate([-25, -25, 0]) leg_body();
        union() {
            // Alignment cone
            cylinder(h=cone_h, d1=cone_d1, d2=cone_d2);
            translate([0, 0, -0.199]) cylinder(h=0.2, d=cone_d1);
            // Screw head recess
            well_h = 3.5;
            translate([0, 0, cone_h - 0.1]) cylinder(h=well_h + 0.1, d=16);
            // Screw hole
            translate([0, 0, cone_h + well_h - 0.1])
                cylinder_outer(h=height - cone_h - well_h + 0.2, r=screw_hole_d / 2);
        }
    }
}

// Foot plate
module plate(height) {
    difference() {
        union() {
            // Foot plate body
            translate([-leg_width / 2, -leg_width / 2, 0])
                leg_body(height=height);
            // Alignment body
            translate([0, 0, height - 0.001])
                difference() {
                    // Alignment cone
                    cylinder(h=14.5, d1=35, d2=20);
                    // Screw head recess
                    translate([0, 0, 9.5 - 0.1]) cylinder(h=5 + 0.2, d=16);
                }
        }
        // Screw hole
        translate([0, 0, -0.1]) cylinder_outer(h=15.5 + 1, r=screw_hole_d / 2);
    }
}

module panel_holder(panel_thickness=3, panel_finger=2) {
    // Panel holder
    translate([-(panel_thickness + panel_finger * 2) / 2 , -2, 0])
    difference() {
        // Main body
        cube([panel_thickness + panel_finger * 2, 24, 20]);
        // Panel slot
        translate([panel_finger, 4, 2]) cube([panel_thickness, 22.1, 20.1]);
        // 45deg cut on body
        rotate([45, 0, 0])
            translate([-0.1, 18.4, -18.4])
                cube([panel_thickness + panel_finger * 2 + 0.2, 15, 30]);
    }
}

panel_thickness = 3;
panel_finger = 2;
panel_holder_width = panel_thickness + panel_finger * 2;
panel_corner_offset = leg_edge_radius + panel_holder_width / 2;

// Rear leg with 2 panel holders
color("red")
translate([0, 0, 50]) union() {
    foot();
    rotate([0, 0, -90])
    translate([leg_width / 2 - panel_corner_offset, leg_width / 2, 0])
        panel_holder(panel_thickness=panel_thickness);
    translate([-(leg_width / 2 - panel_corner_offset), leg_width / 2, 0])
        panel_holder(panel_thickness=panel_thickness);
}

plate_h=1;
color("orange") translate([0, 0, -plate_h]) plate(height=plate_h);
