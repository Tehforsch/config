$env.config = {
  show_banner: false,
  edit_mode: vi,

  keybindings: [
    {
      name: completion_menu
      modifier: control
      keycode: char_f
      mode: [vi_insert vi_normal]
      event: {
        send: executehostcommand,
        cmd: "cd (ls ** | where type == dir | each { |it| $it.name} | str join (char nl) | fzf | decode utf-8 | str trim)"
      }
    }
  ]

}

alias l = ls

# Use nushell functions to define your right and left prompt
def create_left_prompt [] {
    let path_segment = ($env.PWD)

    $path_segment
}

def create_right_prompt [] {
}

$env.PROMPT_COMMAND = { create_left_prompt }
$env.PROMPT_COMMAND_RIGHT = { create_right_prompt }
