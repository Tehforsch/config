rule = {
  matches = {
    {
      { "device.name", "equals", "alsa_card.pci-0000_09_00.1" },
    },
    {
      { "device.name", "equals", "alsa_card.pci-0000_0b_00.4" },
    },
    {
      { "device.name", "equals", "alsa_card.usb-Burr-Brown_from_TI_USB_Audio_CODEC-00" },
    },
  },
  apply_properties = {
    ["device.disabled"] = true,
  },
}

table.insert(alsa_monitor.rules,rule)