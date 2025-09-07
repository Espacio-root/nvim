return {
    cmd = {
      "arduino-language-server",
      "-cli-config", "/home/espacio/.arduino15/arduino-cli.yaml",
      "-fqbn", "arduino:avr:uno",  -- <== YOU MUST SET THIS
      "-cli", "/usr/bin/arduino-cli",
      "-clangd", "/usr/bin/clangd",
    },
}
