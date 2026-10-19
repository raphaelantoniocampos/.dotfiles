# windows port of translate.sh
# usage: translate.ps1 [set|switch|auto]

param([string]$Mode)

Add-Type -AssemblyName System.Windows.Forms, System.Drawing

$Config = "$HOME\.scripts\translate_langs.conf"
$Langs = 'pt-BR', 'en', 'es', 'fr', 'de', 'it', 'ja', 'zh'

# base16 paraiso, same as komorebi
$Bg = [Drawing.ColorTranslator]::FromHtml('#2f1e2e')
$Fg = [Drawing.ColorTranslator]::FromHtml('#e7e9db')
$Accent = [Drawing.ColorTranslator]::FromHtml('#06b6ef')
$Font = [Drawing.Font]::new('Segoe UI', 11)

$Tray = [Windows.Forms.NotifyIcon]@{ Icon = [Drawing.SystemIcons]::Information; Visible = $true }

# notify-send, but with windows notifications
function Notify([string]$Title, [string]$Text, [int]$TimeMs = 5000) {
    $Tray.ShowBalloonTip($TimeMs, $Title, $Text, 'None')
    $script:NotifyTimeMs = $TimeMs
}

# wofi --dmenu, returns the typed text or the selected item
function Show-Dmenu([string]$Prompt, [string[]]$Items, [int]$Width = 600) {
    $form = [Windows.Forms.Form]@{
        FormBorderStyle = 'None'; StartPosition = 'CenterScreen'; TopMost = $true
        ShowInTaskbar = $false; KeyPreview = $true; BackColor = $Bg
    }
    $box = [Windows.Forms.TextBox]@{
        Left = 14; Top = 14; Width = $Width - 28; BorderStyle = 'None'
        BackColor = $Bg; ForeColor = $Fg; Font = $Font; PlaceholderText = $Prompt
    }
    $form.Controls.Add($box)
    $form.ClientSize = [Drawing.Size]::new($Width, $box.Bottom + 14)

    if ($Items) {
        $list = [Windows.Forms.ListBox]@{
            Left = 14; Top = $box.Bottom + 10; Width = $Width - 28; BorderStyle = 'None'
            BackColor = $Bg; ForeColor = $Fg; Font = $Font; IntegralHeight = $false
        }
        $list.Items.AddRange($Items)
        $list.SelectedIndex = 0
        $list.Height = $list.ItemHeight * $Items.Count
        $form.Controls.Add($list)
        $form.ClientSize = [Drawing.Size]::new($Width, $list.Bottom + 14)

        # filter items while typing
        $box.Add_TextChanged({
            $list.Items.Clear()
            $list.Items.AddRange([object[]]@($Items | Where-Object { $_ -like "*$($box.Text)*" }))
            if ($list.Items.Count) { $list.SelectedIndex = 0 }
        })
        $list.Add_MouseClick({ $form.Tag = $list.SelectedItem; $form.Close() })
    }

    $form.Add_KeyDown({
        param($s, $e)
        switch ($e.KeyCode) {
            'Escape' { $e.SuppressKeyPress = $true; $form.Close() }
            'Enter' {
                $e.SuppressKeyPress = $true
                $form.Tag = if ($list -and $list.SelectedItem) { $list.SelectedItem } else { $box.Text }
                $form.Close()
            }
            'Down' { if ($list -and $list.SelectedIndex -lt $list.Items.Count - 1) { $list.SelectedIndex += 1 }; $e.Handled = $true }
            'Up' { if ($list -and $list.SelectedIndex -gt 0) { $list.SelectedIndex -= 1 }; $e.Handled = $true }
        }
    })
    $form.Add_Paint({
        param($s, $e)
        $e.Graphics.DrawRectangle([Drawing.Pen]::new($Accent, 2), 1, 1, $s.Width - 2, $s.Height - 2)
    })
    $form.Add_Shown({ $form.Activate() })

    [void]$form.ShowDialog()
    $form.Tag
    $form.Dispose()
}

function Save-Langs([string]$From, [string]$To) {
    [IO.File]::WriteAllText($Config, "${From}:${To}`n")
}

try {
    # creates default translate conf
    if (-not (Test-Path $Config)) { Save-Langs 'pt-BR' 'en' }

    if ($Mode -eq 'set') {
        # choose new langs
        $From = Show-Dmenu 'origin' $Langs 300
        if (-not $From) { exit }

        $To = Show-Dmenu 'destination' $Langs 300
        if (-not $To) { exit }

        Save-Langs $From $To

        Notify 'updated default languages' "$From → $To"
        exit
    }

    # read langs
    $From, $To = (Get-Content $Config -TotalCount 1).Split(':')

    if ($Mode -eq 'switch') {
        # switch languages
        Save-Langs $To $From

        Notify 'switch languages' "$To → $From"
        exit
    }

    if ($Mode -eq 'auto') {
        Notify '' "Translating (clipboard) - $From → $To"
        $Text = Get-Clipboard -Raw
    }
    else {
        Notify '' "Translating - $From → $To"
        $Text = Show-Dmenu "$From → $To"
    }

    if (-not $Text -or -not $Text.Trim()) { exit }

    # count words
    $WordCount = ($Text -split '\s+' | Where-Object { $_ }).Count

    # notification time based on word count
    $TimeMs = [Math]::Clamp($WordCount * 1000, 2000, 10000)

    # translate, same google endpoint used by translate-shell (trans)
    try {
        $Uri = "http://translate.googleapis.com/translate_a/single?client=gtx&ie=UTF-8&oe=UTF-8&dt=t" +
            "&sl=$From&tl=$To&q=$([uri]::EscapeDataString($Text))"
        $Response = Invoke-RestMethod $Uri
        if ($Response -isnot [array]) { throw 'unexpected response from google translate' }
        $Result = -join $Response[0].ForEach({ $_[0] })
    }
    catch {
        Notify 'translation failed' $_.Exception.Message
        exit 1
    }

    # copy to clipboard
    Set-Clipboard -Value $Result

    # notify
    Notify '(copied to clipboard)' $Result $TimeMs
}
finally {
    # keep the last notification on screen, the tray icon takes it away when disposed
    if ($NotifyTimeMs) { Start-Sleep -Milliseconds $NotifyTimeMs }
    $Tray.Dispose()
}
