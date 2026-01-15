{
  config,
  ...
}: let
  tmc2130 = (overrides: {
    interpolate = true;
    sense_resistor = 0.220;
    driver_IHOLDDELAY = 8;
    driver_TPOWERDOWN = 0;
    driver_TOFF = 3;
    driver_HEND = 1;
    driver_HSTRT = 5;
    driver_TBL = 2;
    driver_PWM_FREQ = 2;
    driver_PWM_GRAD = 2;
    driver_PWM_AMPL = 230;
    driver_PWM_AUTOSCALE = true;
    driver_SGT = 3;
  } // overrides);
in {
  services.klipper = {
    enable = true;
    user = config.defaults.username;
    group = "users";
    settings = {
      exclude_object = { };
      gcode_arcs = {
        resolution = 0.1;
      };
      virtual_sdcard = {
        path = "/var/lib/moonraker/gcodes";
        on_error_gcode = "CANCEL_PRINT";
      };
      stepper_x = {
        step_pin = "PC0";
        dir_pin = "!PL0";
        enable_pin = "!PA7";
        microsteps = 32;
        rotation_distance = 32;
        endstop_pin = "tmc2130_stepper_x:virtual_endstop";
        position_endstop = 0;
        position_max = 250;
        homing_speed = 50;
        homing_retract_dist = 0;
      };
      "tmc2130 stepper_x" = tmc2130 {
        cs_pin = "PG0";
        run_current = 0.281738;
        hold_current = 0.281738;
        diag1_pin = "!PK2";
      };
      stepper_y = {
        step_pin = "PC1";
        dir_pin = "PL1";
        enable_pin = "!PA6";
        microsteps = 32;
        rotation_distance = 32;
        endstop_pin = "tmc2130_stepper_y:virtual_endstop";
        position_max = 210;
        position_min = -4;
        position_endstop = -4;
        homing_retract_dist = 0;
        homing_speed = 50;
      };
      "tmc2130 stepper_y" = tmc2130 {
        cs_pin = "PG2";
        run_current = 0.3480291;
        hold_current = 0.3480291;
        diag1_pin = "!PK7";
      };
      stepper_z = {
        step_pin = "PC2";
        dir_pin = "!PL2";
        enable_pin = "!PA5";
        microsteps = 32;
        rotation_distance = 8;
        endstop_pin = "probe:z_virtual_endstop";
        position_max = 210;
        position_min = -2;
        homing_speed = 12;
      };
      "tmc2130 stepper_z" = tmc2130 {
        cs_pin = "PK5";
        run_current = 0.53033;
        hold_current = 0.53033;
        diag1_pin = "!PK6";
        driver_HEND = 1;
        driver_PWM_GRAD = 4;
        driver_PWM_AMPL = 200;
        driver_SGT = 4;
        stealthchop_threshold = 60;
      };
      extruder = {
        step_pin = "PC3";
        dir_pin = "!PL6";
        enable_pin = "!PA4";
        full_steps_per_rotation = 400;
        microsteps = 32;
        gear_ratio = "50:17";
        rotation_distance = 22.68;
        nozzle_diameter = 0.400;
        filament_diameter = 1.750;
        pressure_advance = 0.04;
        max_extrude_cross_section = 50;
        max_extrude_only_distance = 500;
        max_extrude_only_velocity = 120;
        max_extrude_only_accel = 1250;
        heater_pin = "PE5";
        sensor_type = "ATC Semitec 104GT-2";
        sensor_pin = "PF0";
        min_temp = 0;
        max_temp = 305;
      };
       "tmc2130 extruder" = tmc2130 {
        cs_pin = "PK4";
        run_current = 0.5;
        hold_current = 0.5;
        diag1_pin = "!PK3";
        driver_HEND = 2;
        driver_HSTRT = 4;
        driver_TBL = 1;
      };
      mcu = {
        serial = "/dev/serial/by-id/usb-Prusa_Research__prusa3d.com__Original_Prusa_i3_MK3_CZPX3018X004XK75802-if00";
      };
      homing_override = {
        gcode = "
          G1 Z3
          SET_TMC_CURRENT STEPPER=stepper_x CURRENT=.149155
          SET_TMC_CURRENT STEPPER=stepper_y CURRENT=.182301
          BED_MESH_CLEAR
          G28 X0 Y0
          SET_TMC_CURRENT STEPPER=stepper_x CURRENT={printer.configfile.config[\"tmc2130 stepper_x\"][\"run_current\"]}
          SET_TMC_CURRENT STEPPER=stepper_y CURRENT={printer.configfile.config[\"tmc2130 stepper_y\"][\"run_current\"]}
          CENTER_TOOLHEAD
          G28 Z0
        ";
        axes = "Z";
        set_position_x = 0;
        set_position_y = 0;
        set_position_z = 0;
      };
      probe = {
        pin = "PB4";
        x_offset = 23;
        y_offset = 11;
        speed = 5.0;
      };
      heater_bed = {
        heater_pin = "PG5";
        sensor_type = "EPCOS 100K B57560G104F";
        sensor_pin = "PF2";
        min_temp = 0;
        max_temp = 125;
      };
      bed_mesh = {
        speed = 120;
        horizontal_move_z = 2;
        mesh_min = "34,12";
        mesh_max = "240,198";
        probe_count = "6,6";
        mesh_pps = "3,3";
        algorithm = "lagrange";
        fade_end = 4;
      };
      "heater_fan nozzle_cooling_fan" = {
        pin = "PH5";
        heater = "extruder";
      };
      fan = {
        pin = "PH3";
      };
      "temperature_sensor raspberry_pi" = {
        sensor_type = "temperature_host";
        min_temp = 10;
        max_temp = 100;
      };
      firmware_retraction = {
        retract_length = 1;
        retract_speed = 50;
        unretract_speed = 25;
      };
      input_shaper = {
        shaper_freq_x = 70;
        shaper_type_x = "2hump_ei";
        shaper_freq_y = 46;
        shaper_type_y = "2hump_ei";
      };
      respond = { };
      force_move = {
        enable_force_move = true;
      };
      skew_correction = { };
      printer = {
        kinematics = "cartesian";
        max_velocity = 200;
        max_accel = 3000;
        max_accel_to_decel = 3000;
        max_z_velocity = 12;
        max_z_accel = 1000;
      };
      "static_digital_output debug_led" = {
        pins = "!PB7";
      };
      "output_pin BEEPER_pin" = {
        pin = "PH2";
        pwm = true;
        value = 0;
        shutdown_value = 0;
        cycle_time = 0.001;
        scale = 1000;
      };
      display = {
        lcd_type = "hd44780";
        rs_pin = "PD5";
        e_pin = "PF7";
        d4_pin = "PF5";
        d5_pin = "PG4";
        d6_pin = "PH7";
        d7_pin = "PG3";
        encoder_pins = "^PJ1,^PJ2";
        click_pin = "^!PH6";
        menu_timeout = 30;
      };
      pause_resume = { };
      "gcode_macro START_PRINT" = {
        gcode = "
          {% set BED_PREHEAT_TEMP = params.BED_PREHEAT_TEMP|default(60)|float %}
          {% set BED_TEMP = params.BED_TEMP|default(60)|float %}
          {% set EXTRUDER_PREHEAT_TEMP = params.EXTRUDER_PREHEAT_TEMP|default(170)|float %}
          {% set EXTRUDER_TEMP = params.EXTRUDER_TEMP|default(210)|float %}
          {% set PROBE_TEMP = params.PROBE_TEMP|default(32)|float %}
          {% set PROBE_TIMEOUT = params.PROBE_TIMEOUT|default(90)|float %}
          {% set TRAVEL_SPEED = params.TRAVEL_SPEED|default(5000)|float %}
          G90 ; absolute moves
          M83 ; relative extrusion
          M104 S{EXTRUDER_PREHEAT_TEMP} ; set extruder temp
          M140 S{BED_PREHEAT_TEMP} ; set bed temp
          G28 ; home
          G1 Z0.15 ; lower z for faster PINDA pre-heating
          #PROBE_WAIT TEMP={PROBE_TEMP} TIMEOUT={PROBE_TIMEOUT} ; wait for PINDA to warm
          BED_MESH_CALIBRATE
          # BED_MESH_PROFILE LOAD=default
          M104 S{EXTRUDER_TEMP} ; set extruder temp
          M140 S{BED_TEMP} ; set bed temp
          G1 X0 Y0 Z0.4 F{TRAVEL_SPEED}
          M109 S{EXTRUDER_TEMP} ; wait for extruder temp
          M190 S{BED_TEMP} ; wait for bed temp
          G1 Y-3 F1000 ; go outside print area
          G92 E0
          G1 E8 ; purge bubble
          G1 X60 E9 F1000 ; intro line
          G1 X100 E12.5 F1000 ; intro line
          G92 E0
          M300
          M300
        ";
      };
      "gcode_macro END_PRINT" = {
        gcode = "
          M221 S100 ; set flow back to 100%
          COOLDOWN
          M107 ; turn off fan
          PUSH_BED_FORWARD
          ;M84 ; disable motors
          BED_MESH_CLEAR
        ";
      };
      "gcode_macro COOLDOWN" = {
        gcode = "
          M104 S0 ; turn off extruder
          M140 S0 ; turn off heatbed
        ";
      };
      "gcode_macro PUSH_BED_FORWARD" = {
        gcode = "
          G1 X0 Y{printer.toolhead.axis_maximum.y|float - 5.0} F{params.F|default(3600)|float}
        ";
      };
      "gcode_macro LIFT_TOOLHEAD" = {
        gcode = "
          {% set max_z = printer.toolhead.axis_maximum.z|float %}
          {% set act_z = printer.toolhead.position.z|float %}
          {% if act_z < (max_z - 2.0) %}
            {% set z_safe = 2.0 %}
          {% else %}
            {% set z_safe = max_z - act_z %}
          {% endif %}
          {% if \"xyz\" in printer.toolhead.homed_axes %}
            G1 Z{z_safe} F{params.F|default(1800)|float}
            G90
          {% else %}
            {action_respond_info(\"Printer not homed\")}
          {% endif %}
        ";
      };
      "gcode_macro PARK_TOOLHEAD" = {
        gcode = "
          {% set x_park = printer.toolhead.axis_maximum.x|float - 5.0 %}
          {% set y_park = printer.toolhead.axis_maximum.y|float - 5.0 %}
          {% if \"xyz\" in printer.toolhead.homed_axes %}
            LIFT_TOOLHEAD
            G1 X{x_park} Y{y_park} F{params.F|default(6000)|float}
          {% else %}
            {action_respond_info(\"Printer not homed\")}
          {% endif %}
        ";
      };
      "gcode_macro CENTER_TOOLHEAD" = {
        gcode = "
          {% if \"xyz\" in printer.toolhead.homed_axes %}
            LIFT_TOOLHEAD
            G1 X{printer.toolhead.axis_maximum.x|float / 2} Y{printer.toolhead.axis_maximum.y|float / 2} F{params.F|default(4800)|float}
          {% else %}
            {action_respond_info(\"Printer not homed\")}
          {% endif %}
        ";
      };
      "gcode_macro LOAD_FILAMENT" = {
        gcode = "
          {% set LENGTH1 = params.LENGTH1|default(70)|float %}
          {% set LENGTH2 = params.LENGTH2|default(50)|float %}
          M83
          G92 E0.0
          G1 E{LENGTH1} F400
          G1 E{LENGTH2} F100
          G92 E0.0
          M400
          M300 P0.5
        ";
      };
      "gcode_macro UNLOAD_FILAMENT" = {
        gcode = "
          {% set LENGTH1 = params.LENGTH1|default(30)|float %}
          {% set LENGTH2 = params.LENGTH2|default(70)|float %}
          M83
          G92 E0.0
          G1 E10 F100
          G1 E-{LENGTH1} F2000
          G1 E-{LENGTH2} F1000
          G92 E0.0
          M400
          M300 P1
        ";
      };
      "gcode_macro CHANGE_FILAMENT" = {
        gcode = "
          SAVE_GCODE_STATE NAME=M600_state
          PAUSE
          UNLOAD_FILAMENT
          RESTORE_GCODE_STATE NAME=M600_state
        ";
      };
      "gcode_macro TRAM_Z" = {
        gcode = "
          {% set OFFSET = params.OFFSET|default(20)|float %}
          G28
          SET_KINEMATIC_POSITION Z=-{OFFSET}
          G0 Z{printer.toolhead.axis_maximum.z} F{params.F|default(6000)|float}
          G91
          G0 Z-{OFFSET}
          G90
          M84
          G28
        ";
      };
      "gcode_macro M300" = {
        gcode = "
          {% set S = params.S|default(1000)|int %}
          {% set P = params.P|default(100)|int %}
          SET_PIN PIN=BEEPER_pin VALUE=0.5 CYCLE_TIME={ 1.0/S if S > 0 else 1 }
          G4 P{P}
          SET_PIN PIN=BEEPER_pin VALUE=0
        ";
      };
      "gcode_macro M572" = {
        gcode = "SET_PRESSURE_ADVANCE ADVANCE={S}";
      };
      "gcode_macro G80" = {
        gcode = "
          G28
          BED_MESH_CALIBRATE
          G1 X0 Y0 Z0.4 F4000
        ";
      };
      "gcode_macro G29" = {
        gcode = "
          G28
          BED_MESH_CALIBRATE
          G1 X0 Y0 Z0.4 F4000
        ";
      };
      "gcode_macro G81" = {
        gcode = "BED_MESH_OUTPUT";
      };
      "gcode_macro M860" = {
        gcode = "PROBE_WAIT TEMP={rawparams} TIMEOUT=90";
      };
      "gcode_macro M600" = {
        gcode = "CHANGE_FILAMENT";
      };
      display_status = { };
      "gcode_macro CANCEL_PRINT" = {
        description = "Cancel the actual running print";
        rename_existing = "CANCEL_PRINT_BASE";
        gcode = "
          ##### get user parameters or use default #####
          {% set macro_found = True if printer['gcode_macro _CLIENT_VARIABLE'] is defined else False %}
          {% set client = printer['gcode_macro _CLIENT_VARIABLE'] %}
          {% set allow_park = False if not macro_found
                       else False if client.park_at_cancel is not defined
                       else True  if client.park_at_cancel|lower == 'true'
                       else False %}
          {% set retract = 5.0  if not macro_found else client.cancel_retract|default(5.0)|abs %}
          ##### define park position #####
          {% set park_x = \"\"                                    if not macro_found
                     else \"\"                                    if client.park_at_cancel_x is not defined
                     else \"X=\" + client.park_at_cancel_x|string if client.park_at_cancel_x is not none %}
          {% set park_y = \"\"                                    if not macro_found
                     else \"\"                                    if client.park_at_cancel_y is not defined
                     else \"Y=\" + client.park_at_cancel_y|string if client.park_at_cancel_y is not none %}
          {% set custom_park = True if (park_x|length > 0 or park_y|length > 0) else False %}
          ##### end of definitions #####
          {% if (custom_park or not printer.pause_resume.is_paused) and allow_park %} _TOOLHEAD_PARK_PAUSE_CANCEL {park_x} {park_y} {% endif %}
          _CLIENT_RETRACT LENGTH={retract}
          TURN_OFF_HEATERS
          M106 S0
          # clear pause_next_layer and pause_at_layer as preparation for next print
          SET_PAUSE_NEXT_LAYER ENABLE=0
          SET_PAUSE_AT_LAYER ENABLE=0 LAYER=0
          CANCEL_PRINT_BASE
        ";
      };
      "gcode_macro PAUSE" = {
        description = "Pause the actual running print";
        rename_existing = "PAUSE_BASE";
        gcode = "
          SET_GCODE_VARIABLE MACRO=RESUME VARIABLE=last_extruder_temp VALUE=\"{printer[printer.toolhead.extruder].target}\"
          PAUSE_BASE
          _TOOLHEAD_PARK_PAUSE_CANCEL {rawparams}
        ";
      };
      "gcode_macro RESUME" = {
        description = "Resume the actual running print";
        rename_existing = "RESUME_BASE";
        variable_last_extruder_temp = 0;
        gcode = "
          ##### get user parameters or use default #####
          {% set macro_found = True if printer['gcode_macro _CLIENT_VARIABLE'] is defined else False %}
          {% set client = printer['gcode_macro _CLIENT_VARIABLE'] %}
          {% set velocity = printer.configfile.settings.pause_resume.recover_velocity %}
          {% set sp_move        = velocity if not macro_found else client.speed_move|default(velocity) %}
          ##### end of definitions #####
          M109 S{last_extruder_temp}
          _CLIENT_EXTRUDE
          RESUME_BASE VELOCITY={params.VELOCITY|default(sp_move)}
        ";
      };
      "gcode_macro SET_PAUSE_NEXT_LAYER" = {
        description = "Enable a pause if the next layer is reached";
        gcode = "
          {% set pause_next_layer = printer['gcode_macro SET_PRINT_STATS_INFO'].pause_next_layer %}
          {% set ENABLE = params.ENABLE | default(1) | int != 0 %}
          {% set MACRO = params.MACRO | default(pause_next_layer.call, True) %}
          SET_GCODE_VARIABLE MACRO=SET_PRINT_STATS_INFO VARIABLE=pause_next_layer VALUE=\"{{ 'enable': ENABLE, 'call': MACRO }}\"
        ";
      };
      "gcode_macro SET_PAUSE_AT_LAYER" = {
        description = "Enable/disable a pause if a given layer number is reached";
        gcode = "
          {% set pause_at_layer = printer['gcode_macro SET_PRINT_STATS_INFO'].pause_at_layer %}
          {% set ENABLE = params.ENABLE | int != 0 if params.ENABLE is defined
                     else params.LAYER is defined %}
          {% set LAYER = params.LAYER | default(pause_at_layer.layer) | int %}
          {% set MACRO = params.MACRO | default(pause_at_layer.call, True) %}
          SET_GCODE_VARIABLE MACRO=SET_PRINT_STATS_INFO VARIABLE=pause_at_layer VALUE=\"{{ 'enable': ENABLE, 'layer': LAYER, 'call': MACRO }}\"
        ";
      };
      "gcode_macro SET_PRINT_STATS_INFO" = {
        rename_existing = "SET_PRINT_STATS_INFO_BASE";
        description = "Overwrite, to get pause_next_layer and pause_at_layer feature";
        variable_pause_next_layer = {
          enable = false;
          call = "PAUSE";
        };
        variable_pause_at_layer = {
          enable = false;
          layer = 0;
          call = "PAUSE";
        };
        gcode = "
          {% if pause_next_layer.enable %}
            {action_respond_info(\"%s, forced by pause_next_layer\" % pause_next_layer.call)}
            {pause_next_layer.call} ; execute the given gcode to pause, should be either M600 or PAUSE
            SET_PAUSE_NEXT_LAYER ENABLE=0
          {% elif pause_at_layer.enable and params.CURRENT_LAYER is defined and params.CURRENT_LAYER|int == pause_at_layer.layer %}
            {action_respond_info(\"%s, forced by pause_at_layer [%d]\" % (pause_at_layer.call, pause_at_layer.layer))}
            {pause_at_layer.call} ; execute the given gcode to pause, should be either M600 or PAUSE
            SET_PAUSE_AT_LAYER ENABLE=0
          {% endif %}
          SET_PRINT_STATS_INFO_BASE {rawparams}
        ";
      };
      "gcode_macro _TOOLHEAD_PARK_PAUSE_CANCEL" = {
        description = "Helper: park toolhead used in PAUSE and CANCEL_PRINT";
        gcode = "
          ##### get user parameters or use default #####
          {% set macro_found = True if printer['gcode_macro _CLIENT_VARIABLE'] is defined else False %}
          {% set client = printer['gcode_macro _CLIENT_VARIABLE'] %}
          {% set velocity = printer.configfile.settings.pause_resume.recover_velocity %}
          {% set use_custom     = False if not macro_found
                         else False if client.use_custom_pos is not defined
                         else True  if client.use_custom_pos|lower == 'true'
                         else False %}
          {% set custom_park_x  = 0.0 if not macro_found else client.custom_park_x|default(0.0) %}
          {% set custom_park_y  = 0.0 if not macro_found else client.custom_park_y|default(0.0) %}
          {% set park_dz        = 2.0 if not macro_found else client.custom_park_dz|default(2.0)|abs %}
          {% set sp_hop         = 900  if not macro_found else client.speed_hop|default(15) * 60 %}
          {% set sp_move        = velocity * 60 if not macro_found else client.speed_move|default(velocity) * 60 %}
          ##### get config and toolhead values #####
          {% set origin    = printer.gcode_move.homing_origin %}
          {% set act       = printer.gcode_move.gcode_position %}
          {% set max       = printer.toolhead.axis_maximum %}
          {% set cone      = printer.toolhead.cone_start_z|default(max.z) %} ; height as long the toolhead can reach max and min of an delta
          {% set round_bed = True if printer.configfile.settings.printer.kinematics is in ['delta','polar','rotary_delta','winch']
                        else False %}
          ##### define park position #####
          {% set z_min = params.Z_MIN|default(0)|float %}
          {% set z_park = [[(act.z + park_dz), z_min]|max, (max.z - origin.z)]|min %}
          {% set x_park = params.X       if params.X is defined
                     else custom_park_x  if use_custom
                     else 0.0            if round_bed
                     else (max.x - 5.0) %}
          {% set y_park = params.Y       if params.Y is defined
                     else custom_park_y  if use_custom
                     else (max.y - 5.0)  if round_bed and z_park < cone
                     else 0.0            if round_bed
                     else (max.y - 5.0) %}
          ##### end of definitions #####
          _CLIENT_RETRACT
          {% if \"xyz\" in printer.toolhead.homed_axes %}
            G90
            G1 Z{z_park} F{sp_hop}
            G1 X{x_park} Y{y_park} F{sp_move}
            {% if not printer.gcode_move.absolute_coordinates %} G91 {% endif %}
          {% else %}
            {action_respond_info(\"Printer not homed\")}
          {% endif %}
        ";
      };
      "gcode_macro _CLIENT_EXTRUDE" = {
        description = "Extrudes, if the extruder is hot enough";
        gcode = "
          {% set macro_found = True if printer['gcode_macro _CLIENT_VARIABLE'] is defined else False %}
          {% set client = printer['gcode_macro _CLIENT_VARIABLE'] %}
          {% set use_fw_retract = False if not macro_found
                         else False if client.use_fw_retract is not defined
                         else True  if client.use_fw_retract|lower == 'true' and printer.firmware_retraction is defined
                         else False %}
          {% set length = (params.LENGTH|float) if params.LENGTH is defined
                     else 1.0 if not macro_found
                     else client.unretract|default(1.0) %}
          {% set speed = params.SPEED if params.SPEED is defined
                    else 35 if not macro_found
                    else client.speed_unretract|default(35) %}
          {% set absolute_extrude = printer.gcode_move.absolute_extrude %}
          {% if printer.extruder.can_extrude %}
            {% if use_fw_retract %}
              {% if length < 0 %}
                G10
              {% else %}
                G11
              {% endif %}
            {% else %}
              M83
              G1 E{length} F{(speed|float|abs) * 60}
              {% if absolute_extrude %}
                M82
              {% endif %}
            {% endif %}
          {% else %}
            {action_respond_info(\"Extruder not hot enough\")}
          {% endif %}
        ";
      };
      "gcode_macro _CLIENT_RETRACT" = {
        description = "Retracts, if the extruder is hot enough";
        gcode = "
          {% set macro_found = True if printer['gcode_macro _CLIENT_VARIABLE'] is defined else False %}
          {% set client = printer['gcode_macro _CLIENT_VARIABLE'] %}
          {% set length = (params.LENGTH|float) if params.LENGTH is defined
                     else 1.0 if not macro_found
                     else client.retract|default(1.0) %}
          {% set speed = params.SPEED if params.SPEED is defined
                    else 35 if not macro_found
                    else client.speed_retract|default(35) %}
          _CLIENT_EXTRUDE LENGTH=-{length|float|abs} SPEED={speed|float|abs}
        ";
      };
      "menu __main __setup __probe_calibrate_menu" = {
        type = "list";
        enable = "!toolhead.is_printing";
        name = "Z-Offset Calibration";
      };
      "menu __main __setup __probe_calibrate_menu __probe_calibrate_begin" = {
        type = "command";
        enable = "{not printer.idle_timeout.state == \"Printing\"}";
        name = "[Calibrate]";
        gcode = "
          G28
          G1 X165 Y126 F2500
          PROBE_CALIBRATE
        ";
      };
      "menu __main __setup __probe_calibrate_menu __TESTZ_up_1mm" = {
        type = "command";
        enable = "{not printer.idle_timeout.state == \"Printing\"}";
        name = "^ +1mm,";
        gcode = "TESTZ Z=+1";
      };
      "menu __main __setup __probe_calibrate_menu __TESTZ_down_1mm" = {
        type = "command";
        enable = "{not printer.idle_timeout.state == \"Printing\"}";
        name = "v -1mm,";
        gcode = "TESTZ Z=-1";
      };
      "menu __main __setup __probe_calibrate_menu __TESTZ_up_01mm" = {
        type = "command";
        enable = "{not printer.idle_timeout.state == \"Printing\"}";
        name = "  +0.1mm";
        gcode = "TESTZ Z=+.1";
      };
      "menu __main __setup __probe_calibrate_menu __TESTZ_down_01mm" = {
        type = "command";
        enable = "{not printer.idle_timeout.state == \"Printing\"}";
        name = "  -0.1mm";
        gcode = "TESTZ Z=-.1";
      };
      "menu __main __setup __probe_calibrate_menu __TESTZ_up_001mm" = {
        type = "command";
        enable = "{not printer.idle_timeout.state == \"Printing\"}";
        name = " +0.01mm";
        gcode = "TESTZ Z=+.01";
      };
      "menu __main __setup __probe_calibrate_menu __TESTZ_down_001mm" = {
        type = "command";
        enable = "{not printer.idle_timeout.state == \"Printing\"}";
        name = " -0.01mm";
        gcode = "TESTZ Z=-.01";
      };
      "menu __main __setup __probe_calibrate_menu __probe_calibrate_abort" = {
        type = "command";
        enable = "{not printer.idle_timeout.state == \"Printing\"}";
        name = "[Abort]";
        gcode = "ABORT";
      };
      "menu __main __setup __probe_calibrate_menu __probe_calibrate_accept" = {
        type = "command";
        enable = "{not printer.idle_timeout.state == \"Printing\"}";
        name = "[Accept]";
        gcode = "
          ACCEPT
          G90
          G1 Z10 F500
          SAVE_CONFIG
        ";
      };

  };

  services.moonraker = {
    enable = true;
    allowSystemControl = true;
    user = config.defaults.username;
    group = "users";
    address = "0.0.0.0";
    settings = {
      authorization = {
        trusted_clients = [
          "10.0.0.0/8"
          "127.0.0.0/8"
          "169.254.0.0/16"
          "172.16.0.0/12"
          "192.168.0.0/16"
          "FE80::/10"
          "::1/128"
        ];
        cors_domains = [
          "*.lan"
          "*.local"
          "*://localhost"
          "*://localhost:*"
          "*://my.mainsail.xyz"
          "*://app.fluidd.xyz"
        ];
      };
      octoprint_compat = { };
      history = { };
      update_manager = {
        channel = "dev";
        refresh_interval = 168;
      };
      "update_manager fluidd-config" = {
        type = "git_repo";
        primary_branch = "master";
        path = "~/fluidd-config";
        origin = "https://github.com/fluidd-core/fluidd-config.git";
        managed_services = "klipper";
      };
      "update_manager fluidd" = {
        type = "web";
        channel = "stable";
        repo = "fluidd-core/fluidd";
        path = "~/fluidd";
      };
    };
  };

  services.fluidd = {
    enable = true;
  };

  services.nginx = {
    enable = true;
    clientMaxBodySize = "1000m";
  };
}