/*
 * ACPI Override for MiraMEMS MXC6655 Accelerometer
 * Target: CHUWI MiniBook X (or similar Alder Lake-N)
 * Sensor: MXC6655 (ACPI ID: MDA6655)
 * I2C Bus: I2C0 (\\_SB.PC00.I2C0)
 * I2C Address: 0x15
 */
DefinitionBlock ("mxc6655-override.aml", "SSDT", 1, "CUSTOM", "MXC6655", 0x00000001)
{
    // Reference the existing I2C0 controller and GPIO controller
    // Adjust _SB.GPI0 if your platform uses a different controller name
    External (_SB.PC00.I2C0, DeviceObj)
    External (_SB.GPI0, DeviceObj) // Assuming GPI0 is the correct controller

    Scope (_SB.PC00.I2C0)
    {
        Device (ACCL) // You can rename this if needed (e.g., ACC0)
        {
            Name (_HID, "MDA6655") // Match the Hardware ID
            Name (_UID, One)       // Unique ID

            Method (_CRS, 0, Serialized) // Current Resource Settings
            {
                Local0 = ResourceTemplate ()
                {
                    // I2C Resource
                    I2cSerialBusV2 (
                        0x0015,             // Slave Address: 0x15
                        ControllerInitiated, // Request I2C controller Initiated transaction
                        400000,             // Connection Speed: 400 kHz (0x00061A80) - Adjust if needed
                        AddressingMode7Bit, // 7-bit Address Mode
                        "_SB.PC00.I2C0",  // I2C Controller Reference
                        0x00,               // VendorData - none
                        ResourceConsumer,  // Consumer/Producer Flag
                        )

                    // GPIO Power Enable Resource (Placeholder - Needs Correct Pin & Polarity!)
                    // Assumes a GPIO pin on \\_SB.GPI0 controls power.
                    // ActiveHigh is a guess - change if needed.
                    GpioIo (
                        Exclusive,          // Sharable: Exclusive
                        PullNone,           // Pull config: None (or PullDown if ActiveHigh)
                        0,                  // Debounce Timeout: 0
                        0,                  // Drive Strength: 0
                        IoRestrictionOutputOnly, // IO Restriction: Output Only
                        "_SB.GPI0",       // GPIO Controller Reference
                        0x00,               // ResourceSourceIndex = 0
                        ResourceConsumer,   // Consumer/Producer Flag
                        ) { 0xFFFE }        // Pin Number - !!PLACEHOLDER!! - MUST BE CORRECTED!!

                    // GPIO Interrupt Resource (Placeholder - Needs Correct Pin!)
                    // This assumes the interrupt connects to \\_SB.GPI0
                    // You MUST find the correct pin number from schematics or Windows ACPI
                    GpioInt (
                        Level,              // Trigger type: Level sensitive
                        ActiveHigh,         // Polarity: Active High (Guessing - adjust if needed)
                        Exclusive,          // Sharable: Exclusive
                        PullDefault,        // Pull config: Default
                        0x0000,             // VendorData - none
                        "_SB.GPI0",       // GPIO Controller Reference
                        0x00,               // ResourceSourceIndex = 0
                        ResourceConsumer, // Consumer/Producer Flag
                        )
                        {
                           0xFFFF // Pin Number - !!PLACEHOLDER - MUST BE CORRECTED!!
                        }
                }
                Return (Local0)
            }

            Method (_STA, 0, NotSerialized) // Get Status
            {
                // Assume device is present and functional if this override is loaded
                Return (0x0F) // Present, Enabled, Shown in UI, Functional
            }
        }
    }
}