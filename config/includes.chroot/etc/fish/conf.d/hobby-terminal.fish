# /etc/fish/conf.d/hobby-terminal.fish
# Terminal environment & shell cleanliness for Hobby Linux

# TODO: These weird hacks shouldn't be needed but idk how else to prevent them :(
if status is-interactive
    # disable Kitty keyboard protocol probing (which prevents ghost escape codes in QTerminal)
    set -g fish_features no-kitty-keyboard

    # disable title escape sequences (that also leak ghost characters into QTerminal)
    function fish_title
    end
end
