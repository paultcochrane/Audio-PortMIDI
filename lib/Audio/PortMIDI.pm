use v6.c;

use NativeCall;

class Audio::PortMIDI {

    constant LIB = ('portmidi',v0);
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

    sub Pm_GetErrorText(int32 $errnum) is native(LIB) returns Str { * }

    method error-text(Int $code) returns Str {
        Pm_GetErrorText($code);
    }

    class X::PortMIDI is Exception {
        has Int $.code is required;
        has Str $.what is required;
        has Str $.message;

        method message() returns Str {
            if !$!message.defined {
                my $text = Pm_GetErrorText($!code);
                $!message = "{$!what} : $text";
            }
            $!message;
        }

    }

    my class DeviceInfoX is repr('CStruct') {
	    has int32                          $.struct-version;
	    has Str                            $.interface;
	    has Str                            $.name;
	    has uint32                         $.input;
	    has uint32                         $.output;
	    has uint32                         $.opened;
    }

    class DeviceInfo {
        has DeviceInfoX $.device-info handles <interface name> is required;
        has Int $.device-id is required;

        method input() returns Bool {
            Bool($!device-info.input);
        }
        method output() returns Bool {
            Bool($!device-info.output);
        }
        method opened() returns Bool {
            Bool($!device-info.opened);
        }


    }

    class Event is repr('CStruct') {
	    has int32                       $.message;
	    has int32                       $.timestamp;
    }

    enum Filter (
        Active => (1 +< 0x0E),
        Sysex => (1 +< 0x00),
        Clock => (1 +< 0x08),
        Play => ((1 +< 0x0A) +| (1 +< 0x0C) +| (1 +< 0x0B)),
        Tick => (1 +< 0x09),
        Fd => (1 +< 0x0D),
        Undefined => (1 +< 0x0D),
        Reset => (1 +< 0x0F),
        Realtime => ((1 +< 0x0E) +| (1 +< 0x00) +| (1 +< 0x08) +| (1 +< 0x0A) +| (1 +< 0x0C) +| (1 +< 0x0B) +| (1 +< 0x09) +| (1 +< 0x0D) +| (1 +< 0x0F)),
        Note => ((1 +< 0x19) +| (1 +< 0x18)),
        ChannelAftertouch => (1 +< 0x1D),
        PolyAftertouch => (1 +< 0x1A),
        Aftertouch => ((1 +< 0x1D) +| (1 +< 0x1A) ),
        Program => (1 +< 0x1C),
        Control => (1 +< 0x1B),
        Pitchbend => (1 +< 0x1E),
        Mtc => (1 +< 0x01),
        SongPosition => (1 +< 0x02),
        SongSelect => (1 +< 0x03),
        Tune => (1 +< 0x06),
        Systemcommon => ((1 +< 0x01) +| (1 +< 0x02) +| (1 +< 0x03) +| (1 +< 0x06)),
    );

    class Stream is repr('CPointer')  {

        sub Pm_HasHostError(Stream $stream) is native(LIB) returns int32 { * }

        method has-host-error() returns Bool {
            my $rc = Pm_HasHostError(self);
            Bool($rc);
        }

        sub Pm_SetFilter(Stream $stream , int32 $filters) is native(LIB) returns int32 { * }

        method set-filter(Int $filter) {
            my $rc = Pm_SetFilter(self, $filter);
            if $rc < 0 {
                X::PortMIDI.new(code => $rc, what => 'setting filter').throw;
            }
            True;
        }

        sub Pm_SetChannelMask(Stream $stream, int32 $mask ) is native(LIB) returns int32 { * }

        method set-channel-mask(*@channels where { @channels.elems <= 16 && all(@channels) ~~ ( 0 ..15 ) }) {
            my int $mask = @channels.map(1 +< *).reduce(&[+|]);
            my $rc = Pm_SetChannelMask(self, $mask);
            if $rc < 0 {
                X::PortMIDI.new(code => $rc, what => 'setting channel mask').throw;
            }
            True;
        }

        sub Pm_Abort(Stream $stream) is native(LIB) returns int32 { * }

        method abort() {
            my $rc = Pm_Abort(self);
            if $rc < 0 {
                X::PortMIDI.new(code => $rc, what => "aborting stream").throw;
            }
        }

        sub Pm_Close(Stream $stream) is native(LIB) returns int32 { * }

        method close() {
            my $rc = Pm_Close(self);
            if $rc < 0 {
                X::PortMIDI.new(code => $rc, what => "closing stream").throw;
            }
        }
    
        sub Pm_Synchronize(Stream $stream ) is native(LIB) returns int32 { * }

        method synchronize() {
            my $rc = Pm_Synchronize(self);
            if $rc < 0 {
                X::PortMIDI.new(code => $rc, what => "synchronizing stream").throw;
            }
        }


        sub Pm_Poll(Stream $stream ) is native(LIB) returns int32 { * }

        method poll() returns Bool {
            my $rc = Pm_Poll(self);
            if $rc < 0 {
                X::PortMIDI.new(code => $rc, what => "polling stream").throw;
            }
            Bool($rc);
        }

        sub Pm_Read(Stream $stream, CArray[Event] $buffer, int32 $length) is native(LIB) returns int32 { * }

        proto method read(|c) { * }

        multi method read(Int $length) returns CArray {
            my $a = CArray[Event].new;
            $a[$length - 1] = Event;
            my $rc = Pm_Read(self, $a, $length);
            if $rc < 0 {
                X::PortMIDI.new(code => $rc, what => "reading stream").throw;
            }

            $a;
        }

        sub Pm_Write(Stream $stream, CArray[Event] $buffer, int32  $length ) is native(LIB) returns int32 { * }

        method write(CArray[Event] $buffer, Int $length) {
            my $rc = Pm_Write(self, $buffer, $length);
            if $rc < 0 {
                X::PortMIDI.new(code => $rc, what => "writing stream").throw;
            }
        }

        sub Pm_WriteShort(Stream $stream, int32 $when, int32 $msg) is native(LIB) returns int32 { * }

        sub Pm_WriteSysEx(Stream $stream, int32 $when, Pointer[uint8] $msg) is native(LIB) returns int32 { * }
    }


    multi submethod BUILD() {
        self.initialize();
    }

    sub Pm_Initialize() is native(LIB) returns int32 { * }

    method initialize() {
        my $rc = Pm_Initialize();
        if $rc < 0 {
            X::PortMIDI.new(code => $rc, what => 'initialising portmidi').throw;
        }
    }

    sub Pm_Terminate() is native(LIB) returns int32  { * }

    method terminate() {
        my $rc = Pm_Terminate();
        if $rc < 0 {
            X::PortMIDI.new(code => $rc, what => 'terminating portmidi').throw;
        }
    }

    sub Pm_GetHostErrorText(Str $msg is rw, uint32 $len ) is native(LIB)  { * }

    sub Pm_CountDevices() is native(LIB) returns int32 { * }

    method count-devices() returns Int {
        my $rc = Pm_CountDevices();
        if $rc < 0 {
            X::PortMIDI.new(code => $rc, what => 'count-devices').throw;
        }
        $rc;
    }

    sub Pm_GetDeviceInfo(int32 $id) is native(LIB) returns DeviceInfoX { * }

    method device-info(Int $device-id) returns DeviceInfo {
        DeviceInfo.new(device-info => Pm_GetDeviceInfo($device-id), :$device-id);
    }

    method devices() {
        gather {
            for ^(self.count-devices()) -> $id {
                take self.device-info($id);
            }
        }
    }

    sub Pm_GetDefaultInputDeviceID() is native(LIB) returns int32 { * }

    method default-input-device() returns DeviceInfo {
        my $rc = Pm_GetDefaultInputDeviceID();
        if $rc < 0 {
            X::PortMIDI.new(code => $rc, what => "default-input-device").throw;
        }
        self.device-info($rc);
    }

    sub Pm_GetDefaultOutputDeviceID() is native(LIB) returns int32 { * }

    method default-output-device() returns DeviceInfo {
        my $rc = Pm_GetDefaultOutputDeviceID();
        if $rc < 0 {
            X::PortMIDI.new(code => $rc, what => "default-output-device").throw;
        }
        self.device-info($rc);
    }

    sub Pm_OpenInput(CArray[Stream] $stream, int32 $inputDevice, Pointer $inputDriverInfo, int32 $bufferSize ,&time_proc (Pointer --> int32), Pointer $time_info) is native(LIB) returns int32 { * }

    method open-input(Int $device-id, Int $buffer-size) returns Stream {
        my $stream = CArray[Stream].new(Stream.new);
        my $rc = Pm_OpenInput($stream, $device-id, Pointer, $buffer-size, Code, Pointer);
        if $rc < 0 {
            X::PortMIDI.new(code => $rc, what => "opening input stream").throw;
        }
        $stream[0];
    }

    sub Pm_OpenOutput(CArray[Stream] $stream, int32 $outputDevice, Pointer $outputDriverInfo, int32 $bufferSize ,&time_proc (Pointer --> int32), Pointer $time_info, int32 $latency) is native(LIB) returns int32 { * }

    method open-output(Int $device-id, Int $buffer-size, Int $latency = 0) returns Stream {
        my $stream = CArray[Stream].new(Stream.new);
        my $rc = Pm_OpenOutput($stream, $device-id, Pointer, $buffer-size, Code, Pointer, $latency);
        if $rc < 0 {
            X::PortMIDI.new(code => $rc, what => "opening output stream").throw;
        }
        $stream[0];
    }
}

# vim: expandtab shiftwidth=4 ft=perl6
