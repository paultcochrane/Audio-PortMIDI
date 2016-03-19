# Audio::PortMIDI

Perl6 MIDI access using the portmidi library

## Synopsis

```perl6

use Audio::PortMIDI;

my $pm = Audio::PortMIDI.new;

my $dev = $pm.default-output-device;

say $dev;


my $stream = $pm.open-output($dev, 32);

# Play 1/8th note middle C
my $note-on = Audio::PortMIDI::Event.new(event-type => NoteOn, channel => 1, data-one => 60, data-two => 127);
my $note-off = Audio::PortMIDI::Event.new(event-type => NoteOff, channel => 1, data-one => 60, data-two => 127);

$stream.write($note-on);
sleep .25;
$stream.write($note-off);

$stream.close;

$pm.terminate;

```

See also the [examples](examples) directory for more complete examples.

## Description

This allows you to get MIDI data into or out of your Perl 6 programs. It
provides the minimum abstraction to construct and unpack MIDI messages
and send and receive them via some interface available on your system,
be that ALSA on Linux, CoreMidi on Mac OS/X or whatever it is that
Windows uses.  Depending on the way that the portmidi library is built
there may be other interfaces available.

The MIDI specification itself doesn't particularly provide for the 
arrangement of the events themselves in time and this is assumed to
be the responsibility of the calling application.  

