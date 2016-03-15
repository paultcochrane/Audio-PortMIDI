## Enumerations

# == /usr/include/portmidi.h ==

enum PmError is export (
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
## Structures


# == /usr/include/portmidi.h ==

class PmDeviceInfo is repr('CStruct') is export {
	has int32                         $.structVersion; # int structVersion
	has Str                           $.interf; # const char* interf
	has Str                           $.name; # const char* name
	has int32                         $.input; # int input
	has int32                         $.output; # int output
	has int32                         $.opened; # int opened
}
class PmEvent is repr('CStruct') is export {
	has int32_t                       $.message; # Typedef<PmMessage>->|Typedef<int32_t>->|int|| message
	has int32_t                       $.timestamp; # Typedef<PmTimestamp>->|Typedef<int32_t>->|int|| timestamp
}
## Extras stuff

constant PortMidiStreamPtr is export = Pointer;
## Functions


# == /usr/include/portmidi.h ==

#-From /usr/include/portmidi.h:153
#/**
#    Pm_Initialize() is the library initialisation function - call this before
#    using the library.
#*/
#PMEXPORT PmError Pm_Initialize( void );
sub Pm_Initialize(
                  ) is native(LIB) returns int32 is export { * }

#-From /usr/include/portmidi.h:159
#/**
#    Pm_Terminate() is the library termination function - call this after
#    using the library.
#*/
#PMEXPORT PmError Pm_Terminate( void );
sub Pm_Terminate(
                 ) is native(LIB) returns int32 is export { * }

#-From /usr/include/portmidi.h:180
#/**
#    Test whether stream has a pending host error. Normally, the client finds
#    out about errors through returned error codes, but some errors can occur
#    asynchronously where the client does not
#    explicitly call a function, and therefore cannot receive an error code.
#    The client can test for a pending error using Pm_HasHostError(). If true,
#    the error can be accessed and cleared by calling Pm_GetErrorText(). 
#    Errors are also cleared by calling other functions that can return
#    errors, e.g. Pm_OpenInput(), Pm_OpenOutput(), Pm_Read(), Pm_Write(). The
#    client does not need to call Pm_HasHostError(). Any pending error will be
#    reported the next time the client performs an explicit function call on 
#    the stream, e.g. an input or output operation. Until the error is cleared,
#    no new error codes will be obtained, even for a different stream.
#*/
#PMEXPORT int Pm_HasHostError( PortMidiStream * stream );
sub Pm_HasHostError(PortMidiStreamPtr $stream # Typedef<PortMidiStream>->|void|*
                    ) is native(LIB) returns int32 is export { * }

#-From /usr/include/portmidi.h:187
#/**  Translate portmidi error number into human readable message.
#    These strings are constants (set at compile time) so client has 
#    no need to allocate storage
#*/
#PMEXPORT const char *Pm_GetErrorText( PmError errnum );
sub Pm_GetErrorText(int32 $errnum # PmError
                    ) is native(LIB) returns Str is export { * }

#-From /usr/include/portmidi.h:193
#/**  Translate portmidi host error into human readable message.
#    These strings are computed at run time, so client has to allocate storage.
#    After this routine executes, the host error is cleared. 
#*/
#PMEXPORT void Pm_GetHostErrorText(char * msg, unsigned int len);
sub Pm_GetHostErrorText(Str                           $msg # char*
                       ,uint32                        $len # unsigned int
                        ) is native(LIB)  is export { * }

#-From /usr/include/portmidi.h:218
#/**  Get devices count, ids range from 0 to Pm_CountDevices()-1. */
#PMEXPORT int Pm_CountDevices( void );
sub Pm_CountDevices(
                    ) is native(LIB) returns int32 is export { * }

#-From /usr/include/portmidi.h:261
#*/
#PMEXPORT PmDeviceID Pm_GetDefaultInputDeviceID( void );
sub Pm_GetDefaultInputDeviceID(
                               ) is native(LIB) returns PmDeviceID is export { * }

#-From /usr/include/portmidi.h:263
#/** see PmDeviceID Pm_GetDefaultInputDeviceID() */
#PMEXPORT PmDeviceID Pm_GetDefaultOutputDeviceID( void );
sub Pm_GetDefaultOutputDeviceID(
                                ) is native(LIB) returns PmDeviceID is export { * }

#-From /usr/include/portmidi.h:287
#    The returned structure is owned by the PortMidi implementation and must
#    not be manipulated or freed. The pointer is guaranteed to be valid
#    between calls to Pm_Initialize() and Pm_Terminate().
#*/
#PMEXPORT const PmDeviceInfo* Pm_GetDeviceInfo( PmDeviceID id );
sub Pm_GetDeviceInfo(PmDeviceID $id # Typedef<PmDeviceID>->|int|
                     ) is native(LIB) returns PmDeviceInfo is export { * }

#-From /usr/include/portmidi.h:358
#*/
#PMEXPORT PmError Pm_OpenInput( PortMidiStream** stream,
#                PmDeviceID inputDevice,
#                void *inputDriverInfo,
#                int32_t bufferSize,
#                PmTimeProcPtr time_proc,
#                void *time_info );
sub Pm_OpenInput(Pointer[PortMidiStreamPtr]    $stream # Typedef<PortMidiStream>->|void|**
                ,PmDeviceID                    $inputDevice # Typedef<PmDeviceID>->|int|
                ,Pointer                       $inputDriverInfo # void*
                ,int32_t                       $bufferSize # Typedef<int32_t>->|int|
                ,&time_proc (Pointer --> int32_t) # Typedef<PmTimeProcPtr>->|F:Typedef<PmTimestamp>->|Typedef<int32_t>->|int|| ( void*)*|
                ,Pointer                       $time_info # void*
                 ) is native(LIB) returns int32 is export { * }

#-From /usr/include/portmidi.h:366
#PMEXPORT PmError Pm_OpenOutput( PortMidiStream** stream,
#                PmDeviceID outputDevice,
#                void *outputDriverInfo,
#                int32_t bufferSize,
#                PmTimeProcPtr time_proc,
#                void *time_info,
#                int32_t latency );
sub Pm_OpenOutput(Pointer[PortMidiStreamPtr]    $stream # Typedef<PortMidiStream>->|void|**
                 ,PmDeviceID                    $outputDevice # Typedef<PmDeviceID>->|int|
                 ,Pointer                       $outputDriverInfo # void*
                 ,int32_t                       $bufferSize # Typedef<int32_t>->|int|
                 ,&time_proc (Pointer --> int32_t) # Typedef<PmTimeProcPtr>->|F:Typedef<PmTimestamp>->|Typedef<int32_t>->|int|| ( void*)*|
                 ,Pointer                       $time_info # void*
                 ,int32_t                       $latency # Typedef<int32_t>->|int|
                  ) is native(LIB) returns int32 is export { * }

#-From /usr/include/portmidi.h:434
#PMEXPORT PmError Pm_SetFilter( PortMidiStream* stream, int32_t filters );
sub Pm_SetFilter(PortMidiStreamPtr             $stream # Typedef<PortMidiStream>->|void|*
                ,int32_t                       $filters # Typedef<int32_t>->|int|
                 ) is native(LIB) returns int32 is export { * }

#-From /usr/include/portmidi.h:452
#    All channels are allowed by default
#*/
#PMEXPORT PmError Pm_SetChannelMask(PortMidiStream *stream, int mask);
sub Pm_SetChannelMask(PortMidiStreamPtr             $stream # Typedef<PortMidiStream>->|void|*
                     ,int32                         $mask # int
                      ) is native(LIB) returns int32 is export { * }

#-From /usr/include/portmidi.h:462
#    this call may result in transmission of a partial midi message.
#    There is no abort for Midi input because the user can simply
#    ignore messages in the buffer and close an input device at
#    any time.
# */
#PMEXPORT PmError Pm_Abort( PortMidiStream* stream );
sub Pm_Abort(PortMidiStreamPtr $stream # Typedef<PortMidiStream>->|void|*
             ) is native(LIB) returns int32 is export { * }

#-From /usr/include/portmidi.h:469
#     
#/**
#    Pm_Close() closes a midi stream, flushing any pending buffers.
#    (PortMidi attempts to close open streams when the application 
#    exits -- this is particularly difficult under Windows.)
#*/
#PMEXPORT PmError Pm_Close( PortMidiStream* stream );
sub Pm_Close(PortMidiStreamPtr $stream # Typedef<PortMidiStream>->|void|*
             ) is native(LIB) returns int32 is export { * }

#-From /usr/include/portmidi.h:494
#/**
#    Pm_Synchronize() instructs PortMidi to (re)synchronize to the
#    time_proc passed when the stream was opened. Typically, this
#    is used when the stream must be opened before the time_proc
#    reference is actually advancing. In this case, message timing
#    may be erratic, but since timestamps of zero mean 
#    "send immediately," initialization messages with zero timestamps
#    can be written without a functioning time reference and without
#    problems. Before the first MIDI message with a non-zero
#    timestamp is written to the stream, the time reference must
#    begin to advance (for example, if the time_proc computes time
#    based on audio samples, time might begin to advance when an 
#    audio stream becomes active). After time_proc return values
#    become valid, and BEFORE writing the first non-zero timestamped 
#    MIDI message, call Pm_Synchronize() so that PortMidi can observe
#    the difference between the current time_proc value and its
#    MIDI stream time. 
#    
#    In the more normal case where time_proc 
#    values advance continuously, there is no need to call 
#    Pm_Synchronize. PortMidi will always synchronize at the 
#    first output message and periodically thereafter.
#*/
#PmError Pm_Synchronize( PortMidiStream* stream );
sub Pm_Synchronize(PortMidiStreamPtr $stream # Typedef<PortMidiStream>->|void|*
                   ) is native(LIB) returns int32 is export { * }

#-From /usr/include/portmidi.h:613
#*/
#PMEXPORT int Pm_Read( PortMidiStream *stream, PmEvent *buffer, int32_t length );
sub Pm_Read(PortMidiStreamPtr             $stream # Typedef<PortMidiStream>->|void|*
           ,PmEvent                       $buffer # PmEvent*
           ,int32_t                       $length # Typedef<int32_t>->|int|
            ) is native(LIB) returns int32 is export { * }

#-From /usr/include/portmidi.h:619
#/**
#    Pm_Poll() tests whether input is available, 
#    returning TRUE, FALSE, or an error value.
#*/
#PMEXPORT PmError Pm_Poll( PortMidiStream *stream);
sub Pm_Poll(PortMidiStreamPtr $stream # Typedef<PortMidiStream>->|void|*
            ) is native(LIB) returns int32 is export { * }

#-From /usr/include/portmidi.h:634
#    Sysex data may contain embedded real-time messages.
#*/
#PMEXPORT PmError Pm_Write( PortMidiStream *stream, PmEvent *buffer, int32_t length );
sub Pm_Write(PortMidiStreamPtr             $stream # Typedef<PortMidiStream>->|void|*
            ,PmEvent                       $buffer # PmEvent*
            ,int32_t                       $length # Typedef<int32_t>->|int|
             ) is native(LIB) returns int32 is export { * }

#-From /usr/include/portmidi.h:642
#/**
#    Pm_WriteShort() writes a timestamped non-system-exclusive midi message.
#    Messages are delivered in order as received, and timestamps must be 
#    non-decreasing. (But timestamps are ignored if the stream was opened
#    with latency = 0.)
#*/
#PMEXPORT PmError Pm_WriteShort( PortMidiStream *stream, PmTimestamp when, int32_t msg);
sub Pm_WriteShort(PortMidiStreamPtr             $stream # Typedef<PortMidiStream>->|void|*
                 ,int32_t                       $when # Typedef<PmTimestamp>->|Typedef<int32_t>->|int||
                 ,int32_t                       $msg # Typedef<int32_t>->|int|
                  ) is native(LIB) returns int32 is export { * }

#-From /usr/include/portmidi.h:647
#/**
#    Pm_WriteSysEx() writes a timestamped system-exclusive midi message.
#*/
#PMEXPORT PmError Pm_WriteSysEx( PortMidiStream *stream, PmTimestamp when, unsigned char *msg);
sub Pm_WriteSysEx(PortMidiStreamPtr             $stream # Typedef<PortMidiStream>->|void|*
                 ,int32_t                       $when # Typedef<PmTimestamp>->|Typedef<int32_t>->|int||
                 ,Pointer[uint8]                $msg # unsigned char*
                  ) is native(LIB) returns int32 is export { * }

## Externs

