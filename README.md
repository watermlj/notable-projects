# Cyclic Redundancy Checker
Small final lab from EE262: Embedded Systems. Uses UART protocol to
communicate with a certain value a serial terminal, and calculates
the checksum twice. If these aren't identical, this indicates data corruption.
corruptData may be set to true to purposely shift the data between the
calculations of both checksums, showing a positive check for corruption.
