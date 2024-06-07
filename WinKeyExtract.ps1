function Get-WindowsLicenseKey {
    $regPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion"
    $valueName = "DigitalProductId"

    try {
        $data = Get-ItemProperty -Path $regPath -Name $valueName -ErrorAction Stop
        $key = $data.$valueName

        $productId = $key[52..66]
        $chars = "BCDFGHJKMPQRTVWXY2346789"
        $licenseKey = ""

        for ($i = 24; $i -ge 0; $i--) {
            $r = 0
            for ($j = 14; $j -ge 0; $j--) {
                $r = ($r * 256) -bxor $key[$j]
                $key[$j] = [math]::Floor([double]($r / 24))
                $r %= 24
            }
            $licenseKey = $chars[$r] + $licenseKey
            if (($i % 5) -eq 0 -and $i -ne 0) {
                $licenseKey = "-" + $licenseKey
            }
        }

        return $licenseKey
    } catch {
        Write-Error "Unable to retrieve Windows license key. The operating system may not be activated or the registry key is inaccessible."
    }
}

# Usage
$licenseKey = Get-WindowsLicenseKey
if ($licenseKey) {
    Write-Host "Windows License Key: $licenseKey"
}
