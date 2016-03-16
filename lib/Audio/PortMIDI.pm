use v6.c;
use NativeCall;

class Audio::PortMIDI {

    constant LIB = ('portmidi',v2);
    subset DeviceID of int32;

    enum Error (
        NoError             => 0,
        NoData              => 0,
        GotData             => 1,
        HostError           => -10000,
        InvalidDeviceId     => -9999,
        InsufficientMemory  => -9998,
        BufferTooSmall      => -9997,
        BufferOverflow      => -9996,
        BadPtr              => -9995,
        BadData             => -9994,
        InternalError       => -9993,
        BufferMaxSize       => -9992
    );

    class DeviceInfo is repr('CStruct') {
	    has int32                         $.struct-version;
	    has Str                           $.interface;
	    has Str                           $.name;
	    has int32                         $.input;
	    has int32                         $.output;
	    has int32                         $.opened;
    }

    class Event is repr('CStruct') {
	    has int32                       $.message;
	    has int32                       $.timestamp;
    }

    class Stream is repr('CPointer')  {

        sub Pm_HasHostError(Stream $stream) is native(LIB) returns int32 { * }
    }

    sub Pm_Initialize() is native(LIB) returns int32 { * }

    sub Pm_Terminate() is native(LIB) returns int32  { * }

    sub Pm_GetErrorText(int32 $errnum) is native(LIB) returns Str { * }

    sub Pm_GetHostErrorText(Str $msg, uint32 $len ) is native(LIB)  { * }

    sub Pm_CountDevices() is native(LIB) returns int32 { * }

    sub Pm_GetDefaultInputDeviceID() is native(LIB) returns DeviceID { * }

    sub Pm_GetDefaultOutputDeviceID() is native(LIB) returns DeviceID { * }

    sub Pm_GetDeviceInfo(DeviceID $id) is native(LIB) returns DeviceInfo { * }

    sub Pm_OpenInput(Pointer[Stream] $stream ,DeviceID $inputDevice ,Pointer $inputDriverInfo ,int32 $bufferSize ,&time_proc (Pointer --> int32) ,Pointer $time_info) is native(LIB) returns int32 { * }

    sub Pm_OpenOutput(Pointer[Stream] $stream ,DeviceID $outputDevice ,Pointer $outputDriverInfo ,int32 $bufferSize ,&time_proc (Pointer --> int32) ,Pointer $time_info ,int32 $latency) is native(LIB) returns int32 { * }

    sub Pm_SetFilter(Stream $stream , int32 $filters) is native(LIB) returns int32 { * }

    sub Pm_SetChannelMask(Stream $stream, int32 $mask ) is native(LIB) returns int32 { * }

    sub Pm_Abort(Stream $stream) is native(LIB) returns int32 { * }

    sub Pm_Close(Stream $stream) is native(LIB) returns int32 { * }

    sub Pm_Synchronize(Stream $stream ) is native(LIB) returns int32 { * }

    sub Pm_Read(Stream $stream, Event $buffer, int32 $length) is native(LIB) returns int32 { * }

    sub Pm_Poll(Stream $stream ) is native(LIB) returns int32 { * }

    sub Pm_Write(Stream $stream, Event $buffer, int32  $length ) is native(LIB) returns int32 { * }

    sub Pm_WriteShort(Stream $stream, int32 $when, int32 $msg) is native(LIB) returns int32 { * }

    sub Pm_WriteSysEx(Stream $stream, int32 $when, Pointer[uint8] $msg) is native(LIB) returns int32 { * }

}

# vim: expandtab shiftwidth=4 ft=perl6
