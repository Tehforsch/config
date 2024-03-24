rule = {
  matches = {
    {
      { "device.name", "equals", "alsa_card.pci-0000_09_00.1" },
    },
    {
      { "device.name", "equals", "alsa_card.pci-0000_0b_00.4" },
    },
    {
      { "device.name", "equals", "alsa_card.usb-BEHRINGER_UMC1820_F62F2AF7-00" },
    },
  },
  apply_properties = {
    ["device.disabled"] = true,
  },
}

table.insert(alsa_monitor.rules,rule)