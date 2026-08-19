#!/bin/bash

# Outputs available port info for each sink, one line per port.
# Format: sink-name<TAB>port-name<TAB>port-label<TAB>is-active(1|0)
# Only outputs ports that are not "not available".

pactl list sinks 2>/dev/null | awk '
  function emit_ports() {
    if (sink_name == "") return
    for (i = 1; i <= port_count; i++) {
      if (port_available[i]) {
        print sink_name "\t" port_name[i] "\t" port_label[i] "\t" (port_name[i] == active_port ? "1" : "0")
      }
    }
  }

  /^Sink #/ {
    emit_ports()
    sink_name = ""
    port_count = 0
    active_port = ""
    in_ports = 0
    next
  }

  /^	Name:/ {
    sink_name = $2
    next
  }

  /^	Ports:$/ {
    in_ports = 1
    next
  }

  in_ports && /^	Active Port:/ {
    active_port = $3
    in_ports = 0
    next
  }

  in_ports && /^\t\t/ {
    port_count++
    # Line format: "\t\tanalog-output-headphones: Headphones (type: Headphones, ...)"
    sub(/^\t\t/, "")
    split($0, a, ":")
    port_name[port_count] = a[1]
    # Extract label (text after first colon, before parenthetical)
    label = a[2]
    for (i = 3; i <= length(a) - 1; i++) label = label ":" a[i]
    gsub(/^[[:space:]]+/, "", label)
    gsub(/\s*\(type:.*$/, "", label)
    port_label[port_count] = label
    # Check availability
    if ($0 ~ /not available/) {
      port_available[port_count] = 0
    } else {
      port_available[port_count] = 1
    }
    next
  }

  END {
    emit_ports()
  }
'
