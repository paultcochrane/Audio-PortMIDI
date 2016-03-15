use v6;
class ZZ
enum PmError is export = (
   pmNoError => 0,
   pmNoData => 0,
   pmGotData => 1,
   pmHostError => -10000,
   pmInvalidDeviceId => -9999,
   pmInsufficientMemory => -9998,
   pmBufferTooSmall => -9997,
   pmBufferOverflow => -9996,
   pmBadPtr => -9995,
   pmBadData => -9994,
   pmInternalError => -9993,
   pmBufferMaxSize => -9992
);
sub Pm_GetDeviceInfo is native(LIB) returns Pointer[PmDeviceInfo] (PmDeviceID $id) { * }
sub Pm_Read is native(LIB) returns int32 (Pointer[PortMidiStream] $stream, Pointer[PmEvent] $buffer, int32_t $length) { * }
sub Pm_Abort is native(LIB) returns int32 (Pointer[PortMidiStream] $stream) { * }
sub Pm_GetErrorText is native(LIB) returns Str (int32 $errnum) { * }
sub Pm_OpenOutput is native(LIB) returns int32 (Pointer[Pointer[PortMidiStream]] $stream, PmDeviceID $outputDevice, Pointer $outputDriverInfo, int32_t $bufferSize, Pointer[PtrFunc] $time_proc, Pointer $time_info, int32_t $latency) { * }
sub Pm_GetDefaultInputDeviceID is native(LIB) returns PmDeviceID () { * }
sub Pm_Write is native(LIB) returns int32 (Pointer[PortMidiStream] $stream, Pointer[PmEvent] $buffer, int32_t $length) { * }
sub Pm_Close is native(LIB) returns int32 (Pointer[PortMidiStream] $stream) { * }
sub Pm_GetDefaultOutputDeviceID is native(LIB) returns PmDeviceID () { * }
sub Pm_GetHostErrorText is native(LIB)  (Str $msg, uint32 $len) { * }
sub Pm_Terminate is native(LIB) returns int32 () { * }
sub Pm_CountDevices is native(LIB) returns int32 () { * }
sub Pm_WriteSysEx is native(LIB) returns int32 (Pointer[PortMidiStream] $stream, int32_t $when, Pointer[uint8] $msg) { * }
sub Pm_Synchronize is native(LIB) returns int32 (Pointer[PortMidiStream] $stream) { * }
sub Pm_WriteShort is native(LIB) returns int32 (Pointer[PortMidiStream] $stream, int32_t $when, int32_t $msg) { * }
sub Pm_Poll is native(LIB) returns int32 (Pointer[PortMidiStream] $stream) { * }
sub Pm_SetFilter is native(LIB) returns int32 (Pointer[PortMidiStream] $stream, int32_t $filters) { * }
sub Pm_HasHostError is native(LIB) returns int32 (Pointer[PortMidiStream] $stream) { * }
sub Pm_SetChannelMask is native(LIB) returns int32 (Pointer[PortMidiStream] $stream, int32 $mask) { * }
sub Pm_OpenInput is native(LIB) returns int32 (Pointer[Pointer[PortMidiStream]] $stream, PmDeviceID $inputDevice, Pointer $inputDriverInfo, int32_t $bufferSize, Pointer[PtrFunc] $time_proc, Pointer $time_info) { * }
sub Pm_Initialize is native(LIB) returns int32 () { * }
class PmDeviceInfo is repr('CStruct') is export {
	has int32	$.structVersion;
	has Str	$.interf;
	has Str	$.name;
	has int32	$.input;
	has int32	$.output;
	has int32	$.opened;
}
class PmEvent is repr('CStruct') is export {
	has int32_t	$.message;
	has int32_t	$.timestamp;
}
