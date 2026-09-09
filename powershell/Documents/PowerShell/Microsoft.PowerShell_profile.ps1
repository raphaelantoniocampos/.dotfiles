function prompt()
{
    if($_last = Get-History | Select-Object -Last 1)
    {
        "$($_last.Duration.ToString())> "
    }
}

$Env:STARSHIP_CONFIG = "C:\Users\$Env:USERNAME\.config\starship.toml"
$Env:KOMOREBI_CONFIG_HOME = "C:\Users\$Env:USERNAME\.config\komorebi"

Invoke-Expression (&starship init powershell)
Invoke-Expression (& { (zoxide init powershell | Out-String) })

Set-Alias v nvim
Set-Alias ff fastfetch
Set-Alias ls lsd
Set-Alias cat bat
Set-Alias trp Remove-ItemSafely
Set-Alias lg lazygit
Set-Alias stow winstow
Set-Alias -Name cd -Value z -Scope Global -Option Constant,AllScope -Force

function uvr
{
    uv run $args
}

function km
{
    Stop-Process -Name whkd, komorebi, komorebi-bar -Force -ErrorAction SilentlyContinue
    komorebic start --bar --whkd
}
