# omarchy-audio

An enhanced audio panel for [Omarchy](https://omarchy.org/) that shows audio output ports as separate selectable items.

## What it does

By default, Omarchy's audio panel shows one entry per sink device. This plugin expands each sink into its available ports (e.g., Headphones, Line Out) so you can switch between them directly from the panel.

### Before
- Built-in Audio Analog Stereo (single entry)

### After
- Built-in Audio Analog Stereo - Headphones
- Built-in Audio Analog Stereo - Line Out

## Installation

### Using git clone

```bash
omarchy plugin clone shafayetejaman/omarchy-audio
```

This will:
1. Clone the plugin to `~/.config/omarchy/plugins/shafayet.audio/`
2. Automatically switch your bar to use the cloned plugin

### Manual installation

```bash
cd ~/.config/omarchy/plugins/
git clone https://github.com/shafayetejaman/omarchy-audio.git shafayet.audio
chmod +x shafayet.audio/port-list.sh
```

Then update `~/.config/omarchy/shell.json` to use the new plugin:

```json
{
  "bar": {
    "layout": {
      "right": [
        { "id": "shafayet.audio" }
      ]
    }
  }
}
```

The shell will hot-reload automatically when files change.

## Uninstalling

```bash
omarchy refresh shell
```

This resets the shell to default configuration, using the built-in `omarchy.audio` plugin.

## Requirements

- [Omarchy](https://omarchy.org/) Linux distribution
- PipeWire with PulseAudio compatibility layer
- `pactl` (part of PulseAudio or PipeWire-PulseAudio)

## How it works

1. A helper script (`port-list.sh`) queries `pactl list sinks` to get port information
2. The panel queries this script every 5 seconds when open
3. Sinks with multiple available ports are expanded into separate entries
4. Selecting a port entry calls `pactl set-sink-port` to switch the active port

## License

MIT
