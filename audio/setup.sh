# https://gist.github.com/lukassup/9ac6394cf4c952f3d5b9a11743317c57

mkdir -p ~/.config/pipewire/pipewire.conf.d
mkdir -p ~/.config/pipewire/jack.conf.d/

cat > ~/.config/pipewire/jack.conf.d/10-reaper.conf << EOF
jack.rules = [
    {
        matches = [
            { client.name                = "REAPER" },
            { application.process.binary = "reaper" }
        ]
        actions = {
            update-props = {
                node.latency       = 256/96000
                node.rate          = 1/96000
                node.quantum       = 256/96000
                node.lock-quantum  = true
                node.force-quantum = 256
            }
        }
    }
]
EOF
