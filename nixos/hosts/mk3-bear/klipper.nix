{
  services.klipper = {
    user = "root";
    group = "root";
    enable = true;
    firmwares = {
      mcu = {
        enable = true;
        # Generate this config by running klipper-genconf
        # Currently broken: https://github.com/NixOS/nixpkgs/pull/200228
        # Workaround: Run nix-shell -p python3 --command klipper-genconf instead
        configFile = ./avr.cfg;
        serial = "/dev/serial/by-id/usb-Arduino__www.arduino.cc__0042_55639303235351D01152-if00";
      };
    };
    settings = {
      printer = {
        kinematics = "corexy";
        max_velocity = 300;
        max_accel = 2000;
        max_z_velocity = 5;
        max_z_accel = 100;
      };
      mcu = {
        serial = "/dev/serial/by-id/usb-Arduino__www.arduino.cc__0042_55639303235351D01152-if00";
      };
      display = {
        lcd_type = "st7920";
        cs_pin = "ar16";
        sclk_pin = "ar23";
        sid_pin = "ar17";
        encoder_pins = "^ar31, ^ar33";
        click_pin = "^!ar35";
        kill_pin = "^!ar41";
      };
      stepper_x = {
        step_pin = "ar54";
        dir_pin = "ar55";
        enable_pin = "!ar38";
        microsteps = 16;
        rotation_distance = 32;
        endstop_pin = "^!ar3"; #tmc2130_stepper_x:virtual_endstop
        position_min = -16.4;
        position_endstop = -16.4;
        position_max = 205;
        homing_speed = 60;
      };
      "tmc2208 stepper_x" = {
        uart_pin = "ar64";
        interpolate = true;
        run_current = 0.800;
        sense_resistor = 0.110;
        stealthchop_threshold = 999999;
      };
      stepper_y = {
        step_pin = "ar60";
        dir_pin = "ar61";
        enable_pin = "!ar56";
        microsteps = 16;
        rotation_distance = 32;
        endstop_pin = "^!ar14"; # tmc2130_stepper_y:virtual_endstop
        position_endstop = 0;
        position_max = 208;
        homing_speed = 60;
      };
      "tmc2208 stepper_y" = {
        uart_pin = "ar44";
        interpolate = true;
        run_current = 0.800;
        sense_resistor = 0.110;
        stealthchop_threshold = 999999;
      };
      stepper_z = {
        step_pin = "ar46";
        dir_pin = "ar48";
        enable_pin = "!ar62";
        microsteps = 16;
        rotation_distance = 8;
        endstop_pin = "probe:z_virtual_endstop";
        position_min = -3;
        position_max = 220;
      };
      "tmc2208 stepper_z" = {
        uart_pin = "ar59";
        interpolate = true;
        run_current = 0.750;
        sense_resistor = 0.110;
        stealthchop_threshold = 999999;
      };
      extruder = {
        step_pin = "ar26";
        dir_pin = "ar28";
        enable_pin = "!ar24";
        microsteps = 16;
        rotation_distance = 7.52;
        nozzle_diameter = 0.400;
        filament_diameter = 1.750;
        heater_pin = "ar10";
        sensor_type = "EPCOS 100K B57560G104F";
        sensor_pin = "analog13";
        pullup_resistor = 4500;
        max_extrude_cross_section = 100.0;
        max_extrude_only_distance = 200.0;
        min_temp = 0;
        max_temp = 300;
        control = "pid";
        pid_kp = 16.511;
        pid_ki = 0.548;
        pid_kd = 124.453;
        pressure_advance = 0.288;
      };
      "tmc2208 extruder" = {
        uart_pin = "ar63";
        interpolate = true;
        run_current = 0.750;
        sense_resistor = 0.110;
        stealthchop_threshold = 999999;
      };
      "gcode_macro PARK_extruder".gcode = "
        G92 E0
        G1 E4 F500
        G92 E0
        G1 E-2 F2000
        G4 P2500
        G92 E0
        G1 E-140 F2000
        G92 E0
      ";
      "gcode_macro T0".gcode = "
        PARK_{printer.toolhead.extruder}
        ACTIVATE_EXTRUDER EXTRUDER=extruder
        G92 E0
        G1 E145 F2000
        G92 E0
      ";
      extruder1 = {
        step_pin = "ar36";
        dir_pin = "ar34";
        enable_pin = "!ar30";
        microsteps = 16;
        rotation_distance = 7.52;
        nozzle_diameter = 0.400;
        filament_diameter = 1.750;
        max_extrude_cross_section = 100.0;
        max_extrude_only_distance = 200.0;
        pressure_advance = 0.288;
      };
      "tmc2208 extruder1" = {
        uart_pin = "ar42";
        interpolate = true;
        run_current = 0.750;
        sense_resistor = 0.110;
        stealthchop_threshold = 999999;
      };
      "gcode_macro PARK_extruder1".gcode = "
        G92 E0
        G1 E4 F500
        G92 E0
        G1 E-2 F2000
        G4 P2500
        G92 E0
        G1 E-140 F2000
        G92 E0
      ";
      "gcode_macro T1".gcode = "
        PARK_{printer.toolhead.extruder}
        ACTIVATE_EXTRUDER EXTRUDER=extruder1
        G92 E0
        G1 E145 F2000
        G92 E0
      ";
      heater_bed = {
        heater_pin = "ar8";
        sensor_type = "EPCOS 100K B57560G104F";
        sensor_pin = "analog14";
        min_temp = 0;
        max_temp = 110;
        control = "pid";
        pid_kp = 70.936;
        pid_ki = 0.981;
        pid_kd = 1282.164;
      };
      fan.pin = "ar9";
      "heater_fan noctua_fan".pin = "ar57";
      "output_pin BEEPER_pin" = {
        pin = "ar37";
        pwm = true;
        value = 0;
        shutdown_value = 0;
        cycle_time = 0.001;
      };
      "output_pin power" = {
        pin = "!ar12";
        value = 1;
      };
      "gcode_macro M80".gcode = "SET_PIN PIN=power VALUE=1"; # power on
      "gcode_macro M81".gcode = "SET_PIN PIN=power VALUE=0"; # power off
      "gcode_macro M300".gcode = "
        # Use a default 1kHz tone if S is omitted.
        {% set S = params.S|default(1000)|int %}
        # Use a 10ms duration is P is omitted.
        {% set P = params.P|default(100)|int %}
        SET_PIN PIN=BEEPER_pin VALUE=0.5 CYCLE_TIME={ 1.0/S if S > 0 else 1 }
        G4 P{P}
        SET_PIN PIN=BEEPER_pin VALUE=0
      ";
      "gcode_macro M600".gcode = "
        {% set X = params.X|default(50)|float %}
        {% set Y = params.Y|default(0)|float %}
        {% set Z = params.Z|default(10)|float %}
        SAVE_GCODE_STATE NAME=M600_state
        PAUSE
        G91
        G1 E-.8 F2700
        G1 Z{Z}
        G90
        G1 X{X} Y{Y} F3000
        G91
        G1 E-1000 F1000 # Retract 1 meter
        RESTORE_GCODE_STATE NAME=M600_state
      ";
      "gcode_macro G29".gcode = "BED_MESH_CALIBRATE";
      "gcode_macro PRINT_START".gcode = "
         {% set BED_TEMP = params.BED_TEMP|default(60)|float %}
         {% set EXTRUDER_TEMP = params.EXTRUDER_TEMP|default(190)|float %}
         M140 S{BED_TEMP}             ; start heating bed
         M104 S{EXTRUDER_TEMP}        ; start heating hotend
         G21                          ; metric values
         G90                          ; absolute pos
         M82                          ; set extruder to absolute mode
         G28                          ; home
         G29                          ; auto bed leveling
         G1 X0 Y0 Z1 F2000            ; move to origin
         G92 E0                       ; reset extrusion
         M190 S{BED_TEMP}             ; wait on bed temp
         M109 S{EXTRUDER_TEMP}        ; wait on hotend temp
         G1 Z0                        ; move nozzle to bed
         G1 X80 E12 F500              ; begin nozzle priming
         G1 X140 E15 F500             ; end nozzle priming
         G92 E0                       ; reset extrusion
         M117 Printing...
      ";
      "gcode_macro PRINT_END".gcode = "
         M104 S0     ; turn off extruder
         M140 S0     ; turn off bed
         G91         ; relative positioning
         G1 E-1 F300 ; retract the filament a bit
	       G90	       ; absolute coordinates
         G1 X0 Y180  ; move Y axis away
         M107        ; turn off fan
         M84         ; disable motors
         M109 R50    ; wait for extruder to cool to 50C
         M81         ; turn off psu
	       M117 Print finished!
      ";
      bltouch = {
        sensor_pin = "^ar18";
        control_pin = "ar11";
        probe_with_touch_mode = true;
        x_offset = 33;
        y_offset = 10;
        z_offset = 1.75;
        samples = 3;
        sample_retract_dist = 5.0;
        samples_tolerance = 0.1;
        samples_tolerance_retries = 15;
      };
      bed_mesh = {
        mesh_min = "20, 11";
        mesh_max = "200, 190";
        probe_count = "3,3";
      };
      bed_screws = {
        screw1 = "1,1";
        screw2 = "193,0";
        screw3 = "193,207";
        screw4 = "1,207";
      };
      screws_tilt_adjust = {
        screw1 = "1,1";
        screw1_name = "bottom left screw";
        screw2 = "162,0";
        screw2_name = "bottom right screw";
        screw3 = "162,190";
        screw3_name = "top right screw";
        screw4 = "1,190";
        screw4_name = "top left screw";
      };
      homing_override = {
        gcode = "
          G90 ; Use absolute position mode
          G1 Z5 ; Move up 5mm
          G28
        ";
        set_position_z = 0.0;
      };
      "temperature_sensor raspberry_pi" = {
        sensor_type = "temperature_host";
        min_temp = 10;
        max_temp = 100;
      };
      pause_resume = {};
      display_status = {};
      virtual_sdcard.path = "/root/gcode-files";
      "gcode_macro PAUSE" = {
        description = "Pause the actual running print";
        rename_existing = "PAUSE_BASE";
        gcode = "
        ##### set defaults #####
        {% set x = params.X|default(200) %}
        {% set y = params.Y|default(200) %}
         {% set z = params.Z|default(10)|float %}
        {% set e = params.E|default(5) %}
        ##### calculate save lift position #####
        {% set max_z = printer.toolhead.axis_maximum.z|float %}
        {% set act_z = printer.toolhead.position.z|float %}
        {% set lift_z = z|abs %}
        {% if act_z < (max_z - lift_z) %}
            {% set z_safe = lift_z %}
        {% else %}
            {% set z_safe = max_z - act_z %}
        {% endif %}
        ##### end of definitions #####
        PAUSE_BASE
        G91
        {% if printer.extruder.can_extrude|lower == 'true' %}
          G1 E-{e} F2100
        {% else %}
          {action_respond_info(\"Extruder not hot enough\")}
        {% endif %}
        {% if \"xyz\" in printer.toolhead.homed_axes %}
          G1 Z{z_safe}
          G90
          G1 X{x} Y{y} F6000
        {% else %}
          {action_respond_info(\"Printer not homed\")}
        {% endif %}
        ";
      };
      "gcode_macro RESUME" = {
        description = "Resume the actual running print";
        rename_existing = "RESUME_BASE";
        gcode = "
        ##### set defaults #####
        {% set e = params.E|default(5) %}
        #### get VELOCITY parameter if specified ####
        {% if 'VELOCITY' in params|upper %}
            {% set get_params = ('VELOCITY=' + params.VELOCITY)  %}
        {%else %}
            {% set get_params = \" \" %}
        {% endif %}
        ##### end of definitions #####
        G91
        {% if printer.extruder.can_extrude|lower == 'true' %}
            G1 E{e} F2100
        {% else %}
            {action_respond_info(\"Extruder not hot enough\")}
        {% endif %}
        RESUME_BASE {get_params}
        ";
      };
      "gcode_macro CANCEL_PRINT" = {
        description = "Cancel the actual running print";
        rename_existing = "CANCEL_PRINT_BASE";
        gcode = "
        TURN_OFF_HEATERS
        CANCEL_PRINT_BASE
        ";
      };
      input_shaper = {
        shaper_freq_x = 22.22;
        shaper_freq_y = 25.64;
      };
      "menu __main __octoprint" = {
        type = "list";
        enable = false;
        name = "OctoPrint";
      };
      "menu __main __control __psuon" = {
        type = "command";
        name = "Power-on PSU";
        gcode = "M80";
      };
      "menu __main __control __psuoff" = {
        type = "command";
        name = "Power-off PSU";
        gcode = "M81";
      };
      board_pins = {
        aliases = "
          ar0=PE0, ar1=PE1, ar2=PE4, ar3=PE5, ar4=PG5,
          ar5=PE3, ar6=PH3, ar7=PH4, ar8=PH5, ar9=PH6,
          ar10=PB4, ar11=PB5, ar12=PB6, ar13=PB7, ar14=PJ1,
          ar15=PJ0, ar16=PH1, ar17=PH0, ar18=PD3, ar19=PD2,
          ar20=PD1, ar21=PD0, ar22=PA0, ar23=PA1, ar24=PA2,
          ar25=PA3, ar26=PA4, ar27=PA5, ar28=PA6, ar29=PA7,
          ar30=PC7, ar31=PC6, ar32=PC5, ar33=PC4, ar34=PC3,
          ar35=PC2, ar36=PC1, ar37=PC0, ar38=PD7, ar39=PG2,
          ar40=PG1, ar41=PG0, ar42=PL7, ar43=PL6, ar44=PL5,
          ar45=PL4, ar46=PL3, ar47=PL2, ar48=PL1, ar49=PL0,
          ar50=PB3, ar51=PB2, ar52=PB1, ar53=PB0, ar54=PF0,
          ar55=PF1, ar56=PF2, ar57=PF3, ar58=PF4, ar59=PF5,
          ar60=PF6, ar61=PF7, ar62=PK0, ar63=PK1, ar64=PK2,
          ar65=PK3, ar66=PK4, ar67=PK5, ar68=PK6, ar69=PK7,
          analog0=PF0, analog1=PF1, analog2=PF2, analog3=PF3, analog4=PF4,
          analog5=PF5, analog6=PF6, analog7=PF7, analog8=PK0, analog9=PK1,
          analog10=PK2, analog11=PK3, analog12=PK4, analog13=PK5, analog14=PK6,
          analog15=PK7,
          # Marlin adds these additional aliases
          ml70=PG4, ml71=PG3, ml72=PJ2, ml73=PJ3, ml74=PJ7,
          ml75=PJ4, ml76=PJ5, ml77=PJ6, ml78=PE2, ml79=PE6,
          ml80=PE7, ml81=PD4, ml82=PD5, ml83=PD6, ml84=PH2,
          ml85=PH7
        ";
      };
    };
  };
}
