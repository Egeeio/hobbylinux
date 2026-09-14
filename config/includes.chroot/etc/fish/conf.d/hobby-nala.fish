# /etc/fish/conf.d/hobby-nala.fish
# Alias apt and apt-get to nala for interactive sessions

if status is-interactive; and command -q nala
    alias apt="nala"
    alias apt-get="nala"
end
